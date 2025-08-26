import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/notifications.dart';

class NotificationsService {
  static Future<List<Notifications>> fetchNotifications(String receiverId) async {
    final url = Uri.parse('http://15.164.93.30:8888/api/notifications/search');
    //final url = Uri.parse('http://10.0.2.2:8888/api/notifications/search');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'receivers': receiverId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((e) => Notifications.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Notifications (${response.statusCode})');
    }
  }


  static Future<void> markAllAsRead(String receiverId) async {
    final uri = Uri.parse('http://15.164.93.30:8888/api/notifications/allRead');
    //final uri = Uri.parse('http://10.0.2.2:8888/api/notifications/allRead');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'receiver': receiverId, 'is_read': true}),
    );

    if (response.statusCode != 200) {
      throw Exception('모두 읽음 처리 실패');
    }
  }

  static Future<void> markAsRead(String receiverId, int id, int board_types, int board) async {
    final uri = Uri.parse('http://15.164.93.30:8888/api/notifications/allRead');
    //final uri = Uri.parse('http://10.0.2.2:8888/api/notifications/allRead');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'receiver': receiverId, 'id':  id, 'board_types': board_types, 'board': board}),
    );

    if (response.statusCode != 200) {
      throw Exception('모두 읽음 처리 실패');
    }
  }
}
