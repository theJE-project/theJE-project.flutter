import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:start01/screens/Login.dart';
import 'package:start01/screens/Login.SignUp.dart';
import 'package:start01/widgets/header.dart';
import 'screens/home_list_screen.dart'; // 기존 CategoryListScreen 클래스 파일 분리 가정
import 'screens/playlist_screen.dart';     // 플레이리스트 화면
import 'screens/notifications_screen.dart';// 알림 화면
import 'screens/search_screen.dart';       // 검색 화면

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('여기는 아직 안만든 메인페이지 입니다.'));
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Layout(child: child);
      },
      routes: [
        // '/' 경로 -> Layout의 body에 HomePage를 렌더링
        GoRoute(
          path: '/',
          builder: (context, state) => const Home(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Login(),
        ),
        GoRoute(
          path: '/login/signUp',
          builder: (context, state) => const LosingSignUp(),
        ),
        GoRoute(
          path: '/group',
          builder: (context, state) => PlaylistScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => SearchListScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => NotificationsListScreen(),
        ),
      ],
    ),
  ],
);
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Music Share',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.robotoMonoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routerConfig: _router,
    );
  }
}
// =======
//     return MaterialApp(
//       title: 'Simple Board with Tabs',
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: const HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   // 탭별 보여줄 페이지 위젯 리스트
//   static final List<Widget> _pages = <Widget>[
//     HomeListScreen(),       // 홈
//     PlaylistScreen(),           // 플레이리스트
//     Container(),
//     NotificationsListScreen(),      // 알림
//     SearchListScreen(),             // 검색
//   ];
//
//   void _onItemTapped(int index) {
//     /*
//     setState(() {
//       _selectedIndex = index;
//     });
//     */
//     if (index == 2) {
//       // + 버튼 눌렀을 때 동작
//       _showAddDialog();
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }
//
//   void _showAddDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('+ 등록 버튼 눌림'),
//         content: Text('여기서 게시글 작성 등 기능을 추가할 수 있습니다.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('닫기'),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],  // 선택된 페이지 표시
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,  // 아이콘+텍스트 모두 표시
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: '홈',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.playlist_play),
//             label: '플레이리스트',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add, color: Colors.transparent), // + 버튼은 FloatingActionButton으로
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: '알림',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: '검색',
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddDialog,
//         child: Icon(Icons.add, color: Colors.white), // ← 아이콘 색상 흰색 지정
//         backgroundColor: Colors.lightBlue,
//       ),
//     );
//   }
// }
// >>>>>>> kimJH
