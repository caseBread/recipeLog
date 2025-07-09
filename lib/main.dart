import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 임시 로그인 상태 (예제용)
  final bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/': (context) => RootPage(isLoggedIn: isLoggedIn),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class RootPage extends StatelessWidget {
  final bool isLoggedIn;

  const RootPage({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // 로그인 여부에 따라 pushReplacement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    // 리다이렉트 직전에 임시 화면
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(), // 로딩 중 표시
      ),
    );
  }
}
