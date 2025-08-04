import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/music.dart';

class MusicService {
  static Future<List<Music>> fetchMusics(String query) async {
    final uri = Uri.parse('http://10.0.2.2:8888/api/tracks/search?q=$query');
    final response = await http.get(uri);
    final decodedBody = utf8.decode(response.bodyBytes); // 한글 인코딩

    if (response.statusCode == 200) {
      final List data = json.decode(decodedBody);
      print('Data from API: $data');
      return data.map((e) => Music.fromJson(e)).toList();
    } else {
      print('Status code: ${response.statusCode}');
      print('Response body: ${decodedBody}');
      throw Exception('Failed to load musics');
    }
  }
}
