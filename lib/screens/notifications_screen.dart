import 'package:flutter/material.dart';
import '../models/notifications.dart';
import '../services/notifications_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class NotificationsListScreen extends StatefulWidget {
  @override
  _NotificationsListScreenState createState() => _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen> {
  List<Notifications> notifications = [];
  bool loading = true;
  String? error;
  int filter = 0;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final receiverId = prefs.getString('user-id') ?? '';

      if (receiverId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ 로그인이 필요 합니다.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );

        context.go('/');
        setState(() {
          notifications = [];
          loading = false;
        });
      }
      final result = await NotificationsService.fetchNotifications(receiverId);
      setState(() {
        notifications = result;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      print('❌ 알림 가져오기 실패: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final receiverId = prefs.getString('user-id') ?? '';
    if (receiverId.isEmpty) {
      print('⚠️ 로그인된 사용자 ID가 없습니다.');
      return;
    }

    try {
      await NotificationsService.markAllAsRead(receiverId);
      setState(() {
        notifications =
            notifications.map((n) => n.copyWith(isRead: true)).toList().cast<Notifications>();
      });
      print('✅ 모든 알림을 읽음 처리 완료');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모두 읽음 처리 실패: $e'), backgroundColor: Colors.red),
      );
      print('❌ 모두 읽음 처리 실패: $e');
    }
  }

  String getMessage(Notifications n) {
    switch (n.boardTypes) {
      case 4:
        return '회원님의 플레이리스트를 좋아요하였습니다.';
      case 3:
        return '댓글을 남겼습니다.';
      case 2:
        return '팔로우하기 시작했습니다.';
      case 1:
        return '플레이리스트를 만들었습니다.';
      default:
        return '';
    }
  }

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inHours < 1) return '${diff.inMinutes}분 전';
    if (diff.inDays < 1) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return '${date.year}.${date.month}.${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filter == 0
        ? notifications
        : filter == 9
        ? notifications.where((n) => !n.isRead).toList()
        : notifications.where((n) => n.boardTypes == filter).toList();
    final sorted = [...filtered]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('알림'),
        actions: [
          TextButton(
            onPressed: markAllAsRead,
            child: const Text('모두 읽음', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text('에러 발생: $error'))
          : RefreshIndicator(
        onRefresh: fetchNotifications,
        child: Column(
          children: [
            // 필터 탭
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16), // 좌우 여백
                child: Row(
                  children: [
                    buildFilterButton('전체', 0, Colors.blue),
                    buildFilterButton('읽지 않음', 9, Colors.orange),
                    buildFilterButton('좋아요', 4, Colors.red),
                    buildFilterButton('댓글', 3, Colors.green),
                    buildFilterButton('팔로우', 2, Colors.purple),
                    buildFilterButton('플레이리스트', 1, Colors.yellow.shade700),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: sorted.length,
                itemBuilder: (context, index) {
                  final n = sorted[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: !n.isRead ? Colors.blue.shade100 : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text('${n.name} ${getMessage(n)}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (n.content != null && n.content!.isNotEmpty)
                            Text(n.content!),
                          Text(
                            '${timeAgo(n.createdAt)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: !n.isRead
                          ? Icon(Icons.circle, size: 10, color: Colors.blue)
                          : null,
                      onTap: () {},
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterButton(String label, int type, Color color) {
    final isActive = filter == type;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isActive ? color : null,
          foregroundColor: isActive ? Colors.white : Colors.black,
        ),
        onPressed: () {
          setState(() {
            filter = type;
          });
          print('🔍 필터: $label 적용됨');
        },
        child: Text(label),
      ),
    );
  }
}
