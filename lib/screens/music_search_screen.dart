import 'package:flutter/material.dart';
import '../models/music.dart';
import '../services/music_service.dart';
// import 'package:audioplayers/audioplayers.dart'; // AudioPlayer

class MusicSearchScreen extends StatefulWidget {
  @override
  State<MusicSearchScreen> createState() => _MusicSearchScreenState();
}

class _MusicSearchScreenState extends State<MusicSearchScreen> {
  List<Music> musics = [];
  bool loading = false;
  String? error;


// AudioPlayer
//   final audioPlayer = AudioPlayer();
//   String? currentlyPlayingUrl;
//   bool isPlaying = false;

  Future<void> searchMusic(String query) async {
    setState(() {
      loading = true;
      error = null;
      musics = [];
    });
    try {
      final result = await MusicService.fetchMusics(query);
      setState(() {
        musics = result;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // DB 추가 함수
  // DB 추가 함수

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.9, // 전체 화면의 90% 차지
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom + 16,
      ),
      child: Column(
        children: [
          // 닫기 버튼
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // 검색창
          TextField(
            decoration: InputDecoration(labelText: 'Search Music'),
            onSubmitted: searchMusic,
          ),
          const SizedBox(height: 12),

          // 결과 영역
          if (loading)
            CircularProgressIndicator()
          else
            if (error != null)
              Text('Error: $error')
            else
              if (musics.isEmpty)
                Text('검색 결과가 없습니다.')
              else
                Expanded( // <- 중요! ListView가 넘치지 않도록
                  child: ListView.builder(
                    itemCount: musics.length,
                    itemBuilder: (context, index) {
                      final music = musics[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: music.albumCover.isNotEmpty
                              ? Image.network(music.albumCover, width: 50,
                              height: 50,
                              fit: BoxFit.cover)
                              : Icon(Icons.music_note),
                          title: Text(music.title),
                          subtitle: Text(music.artist),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              // addMusicToDb(music);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
