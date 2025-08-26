import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/User.dart';
import '../services/UserService.dart';

// UserProvider를 관리할 Notifier 클래스
class UserNotifier extends StateNotifier<AsyncValue<User>> {
  final UserService _userService;

  UserNotifier() : _userService = UserService(), super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    state = const AsyncValue.loading();
    try {
      final userId = await _userService.getUserId();

      if (userId == null) {
        state = AsyncValue.data(User.empty());
        print('로그인 아이디가 없습니다.');
        return;
      }

      final res = await http.get(Uri.parse('http://15.164.93.30:8888/api/users/my?userId=$userId'));
      if (res.statusCode == 200) {
        final decodedBody = utf8.decode(res.bodyBytes);
        final user = User.fromJson(jsonDecode(decodedBody));
        state = AsyncValue.data(user);

      } else {
        print('⚠️ 사용자 정보를 불러오지 못했습니다. 상태 코드: ${res.statusCode}');
        state = AsyncValue.data(User.empty());
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> login(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user-id', userId);
    await _loadUser();
  }

  // ✨ logout 메서드 수정: 상태 변경 시 오류를 방지합니다.
  Future<void> logout() async {
    try {
      // 로컬 저장소에서 사용자 ID를 안전하게 삭제합니다.
      await _userService.removeUserId();
      // 성공적으로 삭제되면 상태를 비어있는 User 객체로 변경합니다.
      state = AsyncValue.data(User.empty());
    } catch (e, s) {
      // 만약 로그아웃 과정에서 오류가 발생하더라도
      // 사용자에게 에러를 보여주는 대신,
      // 상태를 비어있는 값으로 재설정하여 에러 메시지가 보이지 않도록 합니다.
      print('로그아웃 중 오류가 발생했습니다: $e');
      state = AsyncValue.data(User.empty());
    }
  }
}

// UserNotifier를 사용하는 최종 Provider
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User>>((ref) {
  return UserNotifier();
});