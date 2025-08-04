import 'package:flutter/material.dart';

class PlaylistCreatePage extends StatelessWidget {
  const PlaylistCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("새 플레이리스트 만들기"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '플레이리스트 정보',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload),
                  label: const Text("이미지 업로드"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: '플레이리스트 제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 3,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: '설명',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: '태그 (예: 팝, 록, 발라드)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const Text("공개 설정"),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("공개"),
                    value: "공개",
                    groupValue: "공개",
                    onChanged: (val) {},
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("비공개"),
                    value: "비공개",
                    groupValue: "공개",
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
            const Divider(height: 40),
            const Text(
              '음악 추가',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                hintText: '음악 제목, 아티스트, 앨범으로 검색...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                MusicItem(title: 'Blinding Lights', artist: 'The Weeknd', duration: '3:20'),
                MusicItem(title: 'Watermelon Sugar', artist: 'Harry Styles', duration: '2:54'),
                MusicItem(title: 'Levitating', artist: 'Dua Lipa', duration: '3:23'),
                MusicItem(title: 'Good 4 U', artist: 'Olivia Rodrigo', duration: '2:58'),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("취소"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("플레이리스트 생성"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MusicItem extends StatelessWidget {
  final String title;
  final String artist;
  final String duration;

  const MusicItem({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        color: Colors.grey.shade300,
        child: const Icon(Icons.music_note),
      ),
      title: Text(title),
      subtitle: Text(artist),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(duration),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
            child: const Text("추가"),
          )
        ],
      ),
    );
  }
}