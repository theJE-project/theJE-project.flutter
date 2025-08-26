import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:just_audio/just_audio.dart';
import '../services/CommunitiesService.dart';

class HomeListScreen extends StatefulWidget {
  const HomeListScreen({Key? key}) : super(key: key);

  @override
  State<HomeListScreen> createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  final CommunitiesService service = CommunitiesService();
  final AudioPlayer player = AudioPlayer();

  final ValueNotifier<String?> _playingNotifier = ValueNotifier(null);

  String getImageUrl(Map<String, dynamic>? img) {
    if (img == null) return '';
    final path = img['url'] ?? img['path'] ?? '';
    return 'https://nvugjssjjxtbbjnwimek.supabase.co/storage/v1/object/public/media/$path';
  }

  void togglePlay(Map<String, dynamic> music) async {
    final url = music['preview'] as String?;
    if (url == null) return;

    if (_playingNotifier.value == url) {
      await player.pause();
      _playingNotifier.value = null;
    } else {
      await player.setUrl(url);
      await player.play();
      _playingNotifier.value = url;
    }
  }

  @override
  void dispose() {
    player.dispose();
    _playingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: service.getFeed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('에러: ${snapshot.error}'));
        }

        final communities = snapshot.data ?? [];
        if (communities.isEmpty) {
          return const Center(child: Text('게시글이 없습니다.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: communities.length,
          itemBuilder: (context, index) {
            final c = communities[index];
            final musics = c['musics'] as List<dynamic>? ?? [];

            final createdAt = DateTime.tryParse(c['created_at'] ?? '') ?? DateTime.now();
            final timeAgo = timeago.format(createdAt);

            return GestureDetector(
              onTap: () {
                // 상세보기 처리
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 프로필, 이름, 계정, 시간
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue[500],
                          backgroundImage: (c['users']?['img'] != null && c['users']?['img'] != "")
                              ? NetworkImage(
                              "https://nvugjssjjxtbbjnwimek.supabase.co/storage/v1/object/public/media/${c['users']['img']}")
                              : null,
                          child: (c['users']?['img'] == null || c['users']?['img'] == "") &&
                              c['users']?['name'] != null
                              ? Text(
                            c['users']['name'][0],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c['users']?['name'] ?? '이름 없음',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  '@${c['users']?['account'] ?? 'unknown'}',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  timeAgo,
                                  style: TextStyle(
                                      color: Colors.grey[400], fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.grey[500]),
                          onPressed: () {
                            // 삭제 기능
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 글 내용
                    Text(
                      c['content'] ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    // 음악 리스트
                    if (musics.isNotEmpty)
                      Column(
                        children: musics.map((m) {
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
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            m['titleShort'] ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            m['artistName'] ?? '',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.play_arrow
                                            : Icons.play_arrow,
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
                      ),
                    const SizedBox(height: 12),
                    // 이미지 리스트
                    if (c['images'] != null && (c['images'] as List).isNotEmpty)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth;
                          final images = c['images'] as List;
                          final itemCount = images.length;

                          final maxImagesPerRow = 3;
                          final imagesPerRow =
                          itemCount < maxImagesPerRow ? itemCount : maxImagesPerRow;
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
                                  getImageUrl(img),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(color: Colors.grey[300]),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    const SizedBox(height: 12),
                    // 댓글/좋아요
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.comment_outlined,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              c['comments']?.toString() ?? '0',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            )
                          ],
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            const Icon(Icons.favorite_border,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              c['likes']?.toString() ?? '0',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
