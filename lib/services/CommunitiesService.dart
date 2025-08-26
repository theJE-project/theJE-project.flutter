import 'dart:convert';
import 'package:http/http.dart' as http;
import 'UserService.dart';

class CommunitiesService {
  final String baseUrl = "http://15.164.93.30:8888/api";
  final bool following;
  final int category; // 생성자에서 받을 category
  final UserService _userService = UserService();

  CommunitiesService({this.following = false, this.category = 1});

  Future<List<dynamic>> getCommunities({int? overrideCategory}) async {
    final cat = overrideCategory ?? category;
    try {
      final uri = Uri.parse('$baseUrl/communities').replace(queryParameters: {
        'category': cat.toString(),
      });
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('피드 불러오기 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('피드 불러오기 실패: $e');
      return [];
    }
  }

  Future<List<dynamic>> getCommunitiesByUser({int? overrideCategory}) async {
    final cat = overrideCategory ?? category;
    try {
      final user = await _userService.getUserId();
      if (user == null) {
        print('user-id 없음');
        return [];
      }

      final uri = Uri.parse('$baseUrl/communities/byUser').replace(queryParameters: {
        'category': cat.toString(),
        'user': user,
      });
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('피드 불러오기 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('피드 불러오기 실패: $e');
      return [];
    }
  }

  Future<List<dynamic>> getFollowingCommunities({int? overrideCategory}) async {
    final cat = overrideCategory ?? category;
    try {
      final user = await _userService.getUserId();
      if (user == null) {
        print('user-id 없음');
        return [];
      }

      final uri = Uri.parse('$baseUrl/communities/followee').replace(queryParameters: {
        'category': cat.toString(),
        'user': user,
      });
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('팔로잉 유저 글 불러오기 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('팔로잉 유저 글 불러오기 실패: $e');
      return [];
    }
  }

  Future<List<dynamic>> getFeed({int? overrideCategory}) async {
    final cat = overrideCategory ?? category;
    final userId = await _userService.getUserId();

    if (userId == null) {
      return await getCommunities(overrideCategory: cat);
    } else {
      if(following){
        return await getFollowingCommunities(overrideCategory: cat);
      }
      return await getCommunitiesByUser(overrideCategory: cat);
    }
  }
}
