import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:just_audio/just_audio.dart';
import '../models/User.dart';
import '../providers/UserProvider.dart';
import '../services/CommunitiesService.dart';
import '../services/FollowersService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  String activeTab = 'posts';

  Map<String, dynamic> editForm = {'name': '', 'content': '', 'img': ''};
  bool showEdit = false;

  bool showFollowModal = false;
  String followType = 'followers';
  List<Map<String, dynamic>> followList = [];

  final CommunitiesService postsService = CommunitiesService();
  final CommunitiesService playlistsService = CommunitiesService(category: 2);
  final FollowersService followersService = FollowersService();

  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> playlists = [];

  bool _isLoading = true;

  final AudioPlayer player = AudioPlayer();
  final ValueNotifier<String?> _playingNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  @override
  void dispose() {
    player.dispose();
    _playingNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    try {
      final fetchedPosts = await postsService.getFeed();
      final fetchedPlaylists = await playlistsService.getCommunities();

      if (mounted) {
        setState(() {
          posts = List<Map<String, dynamic>>.from(fetchedPosts);
          playlists = List<Map<String, dynamic>>.from(fetchedPlaylists);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('데이터 로딩 에러: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getImageUrl(dynamic image) {
    if (image == null) return '';
    final String path = image['url'] ?? image['path'] ?? '';
    return 'https://nvugjssjjxtbbjnwimek.supabase.co/storage/v1/object/public/media/$path';
  }

  void openFollowModal(String type, List<Map<String, dynamic>> list) {
    setState(() {
      followType = type;
      showFollowModal = true;
      followList = list;
    });
  }

  void handleFollowToggle(String targetId, bool isFollowing) {
    setState(() {
      followList = followList.map((u) {
        if (u['id'] == targetId) u['isFollowing'] = !isFollowing;
        return u;
      }).toList();
    });
  }

  void handleEditSave(User user) {
    ref.read(userProvider.notifier).logout();
    setState(() {
      showEdit = false;
    });
  }

  void togglePlay(Map<String, dynamic> music) async {
    final url = music['preview'] as String?;
    if (url == null) return;

    try {
      if (_playingNotifier.value == url) {
        await player.pause();
        _playingNotifier.value = null;
      } else {
        await player.setUrl(url);
        await player.play();
        _playingNotifier.value = url;
      }
    } catch (e) {
      print('음악 재생 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return userState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('에러 발생: $e')),
      data: (user) {
        if (user.id.isEmpty) {
          return const Center(child: Text('로그인이 필요합니다.'));
        }

        editForm = {
          'name': user.name,
          'content': user.content,
          'img': user.img ?? '',
        };

        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 프로필 카드
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.blue,
                            backgroundImage: user.img != null && user.img!.isNotEmpty
                                ? NetworkImage("https://nvugjssjjxtbbjnwimek.supabase.co/storage/v1/object/public/media/${user.img}")
                                : null,
                            child: (user.img == null || user.img!.isEmpty)
                                ? Text(
                              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '@${user.account}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Text(user.content.isNotEmpty
                                    ? user.content
                                    : '소개가 없습니다.'),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 8,
                                  children: [
                                    Text('게시물: ${posts.length + playlists.length}'),
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          final list = await followersService
                                              .getFollowList('followers');
                                          openFollowModal('followers',
                                              List<Map<String, dynamic>>.from(list));
                                        } catch (e) {
                                          print('팔로워 목록 로딩 에러: $e');
                                        }
                                      },
                                      child: Text('팔로워: ${followList.where((u) => u['type'] == 'follower').length}'),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          final list = await followersService
                                              .getFollowList('following');
                                          openFollowModal('following',
                                              List<Map<String, dynamic>>.from(list));
                                        } catch (e) {
                                          print('팔로잉 목록 로딩 에러: $e');
                                        }
                                      },
                                      child: Text('팔로잉: ${followList.where((u) => u['type'] == 'following').length}'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 탭 (좋아요 제거)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => activeTab = 'posts'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: activeTab == 'posts'
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                      width: 2),
                                ),
                              ),
                              child: const Center(child: Text('게시물')),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => activeTab = 'playlists'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: activeTab == 'playlists'
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                      width: 2),
                                ),
                              ),
                              child: const Center(child: Text('플레이리스트')),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      _buildTabContent(user),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              if (showFollowModal) _buildFollowModal(user),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent(User user) {
    switch (activeTab) {
      case 'posts':
        return _buildPostsTab(user);
      case 'playlists':
        return _buildPlaylistsTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPostsTab(User user) {
    if (posts.isEmpty) {
      return const Center(child: Text('작성한 글이 없습니다.'));
    }

    return Column(
      children: posts.map((post) {
        final musics = post['musics'] as List<dynamic>? ?? [];
        final images = post['images'] as List<dynamic>? ?? [];
        final createdAt = DateTime.tryParse(post['created_at'] ?? '') ?? DateTime.now();
        final timeAgo = timeago.format(createdAt, locale: 'ko');

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    backgroundImage: user.img != null && user.img!.isNotEmpty
                        ? NetworkImage("https://nvugjssjjxtbbjnwimek.supabase.co/storage/v1/object/public/media/${user.img}")
                        : null,
                    child: (user.img == null || user.img!.isEmpty)
                        ? Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white),
                    )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Text('@${user.account}',
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 8),
                          Text(timeAgo,
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              if (post['title'] != null && post['title'].toString().isNotEmpty)
                Text(post['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              if (post['title'] != null && post['title'].toString().isNotEmpty)
                const SizedBox(height: 4),
              if (post['content'] != null && post['content'].toString().isNotEmpty)
                Text(post['content']),
              const SizedBox(height: 8),
              if (musics.isNotEmpty) _buildMusicList(musics),
              const SizedBox(height: 8),
              if (images.isNotEmpty) _buildImageList(images),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('💬 ${post['commentsCount'] ?? 0}'),
                  const SizedBox(width: 16),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMusicList(List<dynamic> musics) {
    return Column(
      children: musics.map<Widget>((m) {
        return ValueListenableBuilder<String?>(
          valueListenable: _playingNotifier,
          builder: (context, playing, _) {
            final isPlaying = playing == m['preview'];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      m['albumCover'] ?? '',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: 64,
                            height: 64,
                            color: Colors.grey[300],
                            child: const Icon(Icons.music_note),
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m['titleShort'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          m['artistName'] ?? '',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.blue[600],
                    ),
                    onPressed: () => togglePlay(m),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildImageList(List<dynamic> images) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final itemCount = images.length;
        final maxImagesPerRow = 3;
        final imagesPerRow = itemCount < maxImagesPerRow ? itemCount : maxImagesPerRow;
        final spacing = 8 * (imagesPerRow - 1);
        final imageWidth = (maxWidth - spacing) / imagesPerRow;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: images.map<Widget>((img) {
            return Container(
              width: imageWidth,
              height: imageWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                _getImageUrl(img),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    if (playlists.isEmpty) {
      return const Center(child: Text('플레이리스트가 없습니다.'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index] as Map<String, dynamic>?;

        if (playlist == null) return const SizedBox.shrink();

        final String title = playlist['title'] ?? '제목 없음';
        final String hashTags = (playlist['hash']?.toString() ?? '');
        final List<String> hashTagList = hashTags.isNotEmpty ? hashTags.split(',') : [];
        final images = playlist['images'] as List<dynamic>? ?? [];
        final musics = playlist['musics'] as List<dynamic>? ?? [];

        final String imageUrl = images.isNotEmpty
            ? _getImageUrl(images[0])
            : musics.isNotEmpty
            ? musics[0]['albumCover'] ?? ''
            : 'https://via.placeholder.com/150';

        return GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 100),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (hashTagList.isNotEmpty)
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: hashTagList.where((tag) => tag.trim().isNotEmpty).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#${tag.trim()}',
                        style: const TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFollowModal(User user) {
    return Positioned.fill(
      child: Material(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () => setState(() => showFollowModal = false),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          followType == 'followers' ? '팔로워' : '팔로잉',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => showFollowModal = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: followList.isEmpty
                          ? const Center(child: Text('목록이 비어있습니다.'))
                          : ListView.builder(
                        itemCount: followList.length,
                        itemBuilder: (context, index) {
                          final u = followList[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: u['img'] != null && u['img'].toString().isNotEmpty
                                  ? NetworkImage(u['img'])
                                  : null,
                              child: (u['img'] == null || u['img'].toString().isEmpty)
                                  ? Text(u['name']?[0] ?? '?')
                                  : null,
                            ),
                            title: Text(u['name'] ?? ''),
                            subtitle: Text('@${u['account'] ?? ''}'),
                            trailing: u['id'] != user.id
                                ? ElevatedButton(
                              onPressed: () => handleFollowToggle(
                                  u['id'], u['isFollowing'] ?? false),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: (u['isFollowing'] ?? false)
                                      ? Colors.grey.shade300
                                      : Colors.blue),
                              child: Text((u['isFollowing'] ?? false)
                                  ? '팔로잉'
                                  : '팔로우'),
                            )
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
