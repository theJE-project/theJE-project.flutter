import 'dart:convert';
import 'package:http/http.dart' as http;
import 'UserService.dart';

class CommunitiesService {
  final String baseUrl = "http://localhost:8888/api";
  final bool following;
  final UserService _userService = UserService();

  CommunitiesService({this.following = false});

  Future<List<dynamic>> getCommunities({int category = 1}) async {
    try {
      final uri = Uri.parse('$baseUrl/communities').replace(queryParameters: {
        'category': category.toString(),
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

  Future<List<dynamic>> getCommunitiesByUser({int category = 1}) async {
    try {
      final user = await _userService.getUserId();
      if (user == null) {
        print('user-id 없음');
        return [];
      }

      final uri = Uri.parse('$baseUrl/communities/byUser').replace(queryParameters: {
        'category': category.toString(),
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

  Future<List<dynamic>> getFollowingCommunities({int category = 1}) async {
    try {
      final user = await _userService.getUserId();
      if (user == null) {
        print('user-id 없음');
        return [];
      }

      final uri = Uri.parse('$baseUrl/communities/followee').replace(queryParameters: {
        'category': category.toString(),
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

  Future<List<dynamic>> getFeed({int category = 1}) async {
    final userId = await _userService.getUserId();

    if (userId == null) {
      return await getCommunities(category: category);
    } else {
      if(following){
        return await getFollowingCommunities(category: category);
      }
      return await getCommunitiesByUser(category: category);
    }
  }
}
