import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../services/CommunitiesService.dart';

class HomeListScreen extends StatefulWidget {
  const HomeListScreen({Key? key}) : super(key: key);

  @override
  State<HomeListScreen> createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  final CommunitiesService service = CommunitiesService();

  String? previewUrl; // 음악 미리듣기용 URL 상태

  String getImageUrl(Map<String, dynamic>? img) {
    if (img == null) return '';
    final path = img['url'] ?? img['path'] ?? '';
    return 'https://nvugjssjjxtbbjnwimek.supabase.co/storage/v1/object/public/media/$path';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: service.getFeed(category: 1),
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

            final createdAt = DateTime.tryParse(c['created_at'] ?? '') ?? DateTime.now();
            final timeAgo = timeago.format(createdAt);

            return GestureDetector(
              onTap: () {
                // 상세보기 처리 (handleDetail)
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
                    // 프로필, 이름, 계정, 시간 등
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue[500],
                          backgroundImage: c['users']?['img'] != null
                              ? NetworkImage(c['users']['img'])
                              : null,
                          child: c['users']?['img'] == null && c['users']?['name'] != null
                              ? Text(
                            c['users']['name'][0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
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
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  timeAgo,
                                  style: TextStyle(color: Colors.grey[400], fontSize: 10),
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
                    // 여기서부터 이미지 리스트 (부모폭에 맞게 가로 스크롤 없이 보여줌)
                    if (c['images'] != null && (c['images'] as List).isNotEmpty)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth;
                          final images = c['images'] as List;
                          final itemCount = images.length;

                          // 이미지 간격 8, 이미지 크기 동적 계산 (최대 3장까지 한 줄에)
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

                    // 댓글/좋아요
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.comment_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                c['comments']?.toString() ?? '0',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              )
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                c['likes']?.toString() ?? '0',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      ),
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
