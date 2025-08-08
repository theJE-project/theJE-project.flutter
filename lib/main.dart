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
        GoRoute(
          path: '/',
          builder: (context, state) => HomeListScreen(),
        ),
        GoRoute(
          path: '/:id',
          builder: (context, state) => HomeListScreen(),
        )
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
