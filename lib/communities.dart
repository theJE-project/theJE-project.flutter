import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final String apiUrl = 'http://15.164.93.30:8888/api/communities?category=1';
  List<dynamic> communities = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    setState(() {
      loading = true;
    });
    try {
      final res = await http.get(Uri.parse(apiUrl));
      if (res.statusCode == 200) {
        final decoded = json.decode(utf8.decode(res.bodyBytes));
        setState(() {
          communities = decoded;
        });
      } else {
        showError("서버 응답 오류: ${res.statusCode}");
      }
    } catch (e) {
      showError("요청 실패: $e");
    }
    setState(() {
      loading = false;
    });
  }

  String getImageUrl(String path) {
    return "https://nvugjssjjxtbbjnwimek.supabase.co/storage/v1/object/public/media/$path";
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('커뮤니티 피드')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchCommunities,
        child: ListView.builder(
          itemCount: communities.length,
          itemBuilder: (context, index) {
            final c = communities[index];
            return Card(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 유저 정보
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: c['user']['img'] != null
                              ? NetworkImage(c['user']['img'])
                              : null,
                          child: c['user']['img'] == null
                              ? Text(c['user']['name'][0])
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['user']['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text("@${c['user']['account']} · ${c['created_at']}",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 글 내용
                    Text(c['content'],
                        style: const TextStyle(fontSize: 15)),

                    const SizedBox(height: 12),

                    // 음악 카드
                    // 음악 카드
                    if (c['music'] != null)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5FAFF),
                          border: Border.all(color: Color(0xFFD4E7FA)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              c['music']['cover'], // ✅ 음악 커버는 여기서 직접 URL 사용
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c['music']['title'],
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(c['music']['artist'],
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                      ),


                    const SizedBox(height: 12),

                    // 이미지 목록
                    if (c['images'] != null && c['images'].length > 0)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(c['images'].length, (i) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              getImageUrl(c['images'][i]['url']), // 이 함수가 media 포함한 URL로 만들어줘야 함
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                      ),

                    const SizedBox(height: 12),

                    // 댓글/좋아요
                    Row(
                      children: [
                        Icon(Icons.message_outlined,
                            size: 20, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${c['comments'] ?? 0}'),
                        const SizedBox(width: 16),
                        Icon(Icons.favorite_border,
                            size: 20, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${c['likes'] ?? 0}'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}