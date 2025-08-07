// main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:start01/screens/Login.dart';
import 'package:start01/screens/Login.SignUp.dart';
import 'package:start01/widgets/header.dart';

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