import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:start01/providers/CategoriesProvider.dart';
import 'package:start01/providers/UserProvider.dart';
import 'package:start01/models/User.dart';
import 'package:start01/models/Category.dart';

// Notification 모델
class NotificationItem {
  final int id;
  final String content;
  final String createdAt;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.isRead,
  });
}

// 알림 상태 관리
final showNotificationsProvider = StateProvider<bool>((ref) => false);
final notificationsProvider = StateProvider<List<NotificationItem>>((ref) {
  return [
    NotificationItem(id: 1, content: '새로운 댓글이 달렸습니다', createdAt: '5분 전', isRead: false),
    NotificationItem(id: 2, content: '친구 요청이 있습니다', createdAt: '1시간 전', isRead: false),
    NotificationItem(id: 3, content: '게시글이 삭제되었습니다', createdAt: '2시간 전', isRead: true),
  ];
});

// 🧩 Layout 위젯 (Stateful)
class Layout extends ConsumerStatefulWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  ConsumerState<Layout> createState() => _LayoutState();
}

class _LayoutState extends ConsumerState<Layout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) return; // 가운데 + 버튼은 무시


    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/group');
        break;
      case 3:
        context.go('/notifications');
        break;
      case 4:
        context.go('/search');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final userAsyncValue = ref.watch(userProvider);
    final notifications = ref.watch(notificationsProvider);
    final showNotifications = ref.watch(showNotificationsProvider);
    final unreadNotifications = notifications.where((n) => !n.isRead).toList();

    final user = userAsyncValue.value;
    final isUserLoggedIn = user?.name.isNotEmpty ?? false;

    void markNotificationAsRead(NotificationItem notification) {
      final updatedNotifications = notifications.map((n) {
        if (n.id == notification.id) {
          return NotificationItem(
            id: n.id,
            content: n.content,
            createdAt: n.createdAt,
            isRead: true,
          );
        }
        return n;
      }).toList();
      ref.read(notificationsProvider.notifier).state = updatedNotifications;
      ref.read(showNotificationsProvider.notifier).state = false;
    }

    List<BottomNavigationBarItem> buildBottomNavigationItems() {
      return [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.playlist_play),
          label: '플레이리스트',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add, color: Colors.transparent),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none, // 자르지 않도록 설정
            children: [
              const Icon(Icons.notifications),
              if (unreadNotifications.isNotEmpty)
                Positioned(
                  top: -5, // 위로 약간 띄우기
                  left: 12.5, // 왼쪽 여백 추가
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20, // 최소 너비
                      minHeight: 20, // 최소 높이
                    ),
                    child: Text(
                      '${unreadNotifications.length > 9 ? '9+' : unreadNotifications.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: '알림',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '검색',
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => context.go('/'),
          child: Text(
            'MusicShare',
            style: GoogleFonts.pacifico(
              fontSize: 24,
              color: Colors.blue[600],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          if (isUserLoggedIn) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: PopupMenuButton<String>(
                offset: const Offset(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onSelected: (String result) {
                  if (result == 'profile') {
                    context.go('/my');
                  } else if (result == 'logout') {
                    ref.read(userProvider.notifier).logout();
                    context.go('/');
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue[600],
                            child: user!.img != null
                                ? ClipOval(
                              child: Image.network(
                                user.img!,
                                fit: BoxFit.cover,
                                width: 32,
                                height: 32,
                              ),
                            )
                                : Text(
                              user.name[0].toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text('@${user.account}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person_outline, color: Colors.black87),
                        SizedBox(width: 12),
                        Text('프로필'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.black87),
                        SizedBox(width: 12),
                        Text('로그아웃'),
                      ],
                    ),
                  ),
                ],
                child: CircleAvatar(
                  backgroundColor: Colors.blue[600],
                  child: user!.img != null
                      ? ClipOval(
                    child: Image.network(
                      user.img!,
                      fit: BoxFit.cover,
                      width: 32,
                      height: 32,
                    ),
                  )
                      : Text(
                    user.name[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ] else
            TextButton(
              onPressed: () => context.go('/login'),
              child: Text('로그인',
                  style: TextStyle(color: Colors.grey[700])),
            ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[600]),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'MusicShare',
                      style: GoogleFonts.pacifico(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '음악을 공유하는 공간',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '통합 검색',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9999),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
                onChanged: (value) {
                  // TODO: 검색 로직
                },
              ),
            ),
            Expanded(
              child: categoriesAsyncValue.when(
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('에러: $err')),
                data: (categories) => ListView(
                  padding: EdgeInsets.zero,
                  children: categories.map((category) {
                    return ListTile(
                      title: Text(category.name),
                      onTap: () => context.go(category.url),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: widget.child,
      // ✅ 하단 네비게이션
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 2 ? _selectedIndex : _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: buildBottomNavigationItems(),
      ),
      // ✅ 가운데 + 버튼
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/upload'); // 원하는 경로로 이동
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
