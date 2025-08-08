import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences를 관리하는 서비스 클래스
// 'state'라는 속성이 없어 Riverpod 상태를 직접 조작할 수 없습니다.
class UserService {
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user-id');
  }

  // SharedPreferences에서 'user-id'만 삭제하는 기능
  Future<void> removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user-id');
  }
}