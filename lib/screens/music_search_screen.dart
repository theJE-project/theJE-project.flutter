import 'package:flutter/material.dart';
import '../models/music.dart';
import '../services/music_service.dart';

class MusicSearchScreen extends StatefulWidget {
  @override
  State<MusicSearchScreen> createState() => _MusicSearchScreenState();
}

class _MusicSearchScreenState extends State<MusicSearchScreen> {
  List<Music> musics = [];
  bool loading = false;
  String? error;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Music Search')),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Search Music'),
            onSubmitted: searchMusic,
          ),
          if (loading) CircularProgressIndicator(),
          if (error != null) Text('Error: $error'),
          Expanded(
            child: ListView.builder(
              itemCount: musics.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(musics[index].title),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
