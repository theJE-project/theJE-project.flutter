import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:start01/providers/UserProvider.dart'; // UserProvider는 그대로 사용
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:start01/services/CommunitiesService.dart'; // 외부 CommunitiesService import

// 이 파일 내에서만 사용되는 프로바이더
final selectedGenreProvider = StateProvider<String>((ref) => "전체");
final selectedMoodProvider = StateProvider<List<String>>((ref) => ["전체"]);

// 외부 CommunitiesService를 사용하여 데이터를 가져오는 Provider
final communitiesServiceProvider = Provider((ref) => CommunitiesService(category: 2));
final playlistDataProvider = FutureProvider<List<dynamic>>((ref) async {
  final communitiesService = ref.watch(communitiesServiceProvider);
  return communitiesService.getCommunities(overrideCategory: 2);
});

// --- HomeListScreen 위젯 시작 ---
class PlaylistScreen extends ConsumerWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  void _toggleMood(List<String> currentMood, Function(List<String>) onMoodChange, String mood) {
    List<String> newMoods = List.from(currentMood);
    if (mood == "전체") {
      newMoods = ["전체"];
    } else {
      if (newMoods.contains("전체")) {
        newMoods = [mood];
      } else if (newMoods.contains(mood)) {
        newMoods.remove(mood);
      } else {
        newMoods.add(mood);
      }
      if (newMoods.isEmpty) {
        newMoods = ["전체"];
      }
    }
    onMoodChange(newMoods);
  }

  List<dynamic> _filterPlaylists(List<dynamic> playlists, String selectGenre, List<String> selectMood) {
    final emojiRegex = RegExp(r'\p{Emoji_Presentation}|\p{Emoji}\uFE0F', unicode: true);
    final selectMoodCleaned = selectMood.map((mood) => mood.replaceAll(emojiRegex, '').trim()).toList();

    return playlists.where((playlist) {
      final hash = playlist['hash'] as String?;
      final hashArray = hash?.split(',').map((tag) => tag.replaceAll(emojiRegex, '').trim()).toList() ?? [];

      final bool matchesGenre = selectGenre == "전체" || hashArray.contains(selectGenre);
      final bool matchesMood = selectMoodCleaned.contains("전체") || hashArray.any((tag) {
        return selectMoodCleaned.any((mood) => tag.contains(mood));
      });

      return matchesGenre && matchesMood;
    }).toList();
  }

  String _getImageUrl(dynamic image) {
    if (image == null) return '';
    final String path = image['url'] ?? image['path'] ?? '';
    return 'https://nvugjssjjxtbbjnwimek.supabase.co/storage/v1/object/public/media/$path';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);
    final playlistAsyncValue = ref.watch(playlistDataProvider);
    final selectGenre = ref.watch(selectedGenreProvider);
    final selectMood = ref.watch(selectedMoodProvider);
    final bool isLoggedIn = userAsyncValue.valueOrNull != null && userAsyncValue.valueOrNull!.id.isNotEmpty;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('장르', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['전체', 'Pop', '발라드', '댄스', '랩/힙합', 'R&B', '인디음악', '록/메탈', '클래식'].map((genre) {
                final isSelected = selectGenre == genre;
                return ElevatedButton(
                  onPressed: () => ref.read(selectedGenreProvider.notifier).state = genre,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.blue[500] : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(color: Colors.grey[300]!),
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(genre),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            const Text('무드', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['전체', '🏖️ 여름', '🎶 신나는', '😎 기분업', '🚗 드라이브', '💻 집중/작업', '💪 운동', '☕ 카페', '✈️ 여행', '🌿 휴식', '💌 위로', '😢 슬픈', '🔥 응원'].map((mood) {
                final isSelected = selectMood.contains(mood);
                return ElevatedButton(
                  onPressed: () => _toggleMood(selectMood, (newMoods) => ref.read(selectedMoodProvider.notifier).state = newMoods, mood),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.amber[500] : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(color: Colors.grey[300]!),
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(mood),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            const Text('추천 플레이리스트', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            playlistAsyncValue.when(
              data: (playlists) {
                final filteredPlaylists = _filterPlaylists(playlists, selectGenre, selectMood);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filteredPlaylists.length,
                  itemBuilder: (context, index) {
                    final playlist = filteredPlaylists[index];
                    final String title = playlist['title'] ?? '제목 없음';
                    final String hashTags = playlist['hash'] ?? '';
                    final List<String> hashTagList = hashTags.split(',');

                    final images = playlist['images'] as List<dynamic>? ?? [];
                    final musics = playlist['musics'] as List<dynamic>? ?? [];

                    final String imageUrl = images.isNotEmpty
                        ? _getImageUrl(images[0])
                        : musics.isNotEmpty
                        ? musics[0]['albumCover'] ?? ''
                        : 'https://via.placeholder.com/150';

                    return GestureDetector(
                      // onTap: () => context.go('/group/${playlist['id']}'),
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
                                const Icon(Icons.broken_image, size: 100),
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
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: hashTagList.where((tag) => tag.isNotEmpty).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '#${tag.trim()}',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('데이터를 불러오는 데 실패했습니다: $error')),
            ),
          ],
        ),
      ),
    );
  }
}