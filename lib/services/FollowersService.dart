import 'dart:convert';
import 'package:http/http.dart' as http;
import 'UserService.dart';

class FollowersService {
  final String baseUrl = "http://15.164.93.30:8888/api/followers";
  final UserService _userService = UserService();

  // type: 'followers' or 'following'
  Future<List<Map<String, dynamic>>> getFollowList(String type) async {
    try {
      final userId = await _userService.getUserId();
      if (userId == null) {
        print('user-id 없음');
        return [];
      }

      // Spring Boot API에 맞게 path variable 사용
      final uri = Uri.parse('$baseUrl/${type == 'followers' ? 'follower' : 'followee'}/$userId');

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        print('팔로우 리스트 불러오기 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('팔로우 리스트 불러오기 실패: $e');
      return [];
    }
  }

  // 특정 유저가 다른 유저를 팔로잉 중인지 확인
  Future<bool> isFollowing(String targetId) async {
    try {
      final myId = await _userService.getUserId();
      if (myId == null) return false;

      final uri = Uri.parse('$baseUrl/is-following')
          .replace(queryParameters: {'myId': myId, 'targetId': targetId});

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as bool;
      } else {
        print('팔로잉 여부 확인 실패: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('팔로잉 여부 확인 실패: $e');
      return false;
    }
  }

  // 팔로우 생성
  Future<void> follow(String targetId) async {
    try {
      final myId = await _userService.getUserId();
      if (myId == null) return;

      final uri = Uri.parse('$baseUrl');
      final body = jsonEncode({'follower': myId, 'followee': targetId});

      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode != 200) {
        print('팔로우 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('팔로우 실패: $e');
    }
  }

  // 팔로우 취소
  Future<void> unfollow(String targetId) async {
    try {
      final myId = await _userService.getUserId();
      if (myId == null) return;

      final uri = Uri.parse('$baseUrl/delete')
          .replace(queryParameters: {'follower': myId, 'followee': targetId});

      final response = await http.delete(uri);

      if (response.statusCode != 204) {
        print('언팔로우 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('언팔로우 실패: $e');
    }
  }
}

