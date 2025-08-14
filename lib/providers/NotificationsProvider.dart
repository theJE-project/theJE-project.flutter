import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notifications.dart';
import '../services/notifications_service.dart';

// 알림 목록 Provider (Future 기반)
final notificationsProvider = FutureProvider.family<List<Notifications>, String>((ref, receiverId) async {
  return await NotificationsService.fetchNotifications(receiverId);
});

// 알림 목록 수동 갱신용 StateProvider
final manualNotificationsProvider = StateProvider<List<Notifications>>((ref) => []);

// 알림 UI 표시 여부
final showNotificationsProvider = StateProvider<bool>((ref) => false);