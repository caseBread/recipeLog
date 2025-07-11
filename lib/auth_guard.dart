import 'package:flutter/material.dart';
import 'package:recipe_log/utils/auth.utils.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  final bool redirectIfLoggedIn; // 💡 새 옵션 추가

  const AuthGuard({
    super.key,
    required this.child,
    this.redirectIfLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = checkIsLoggedIn();

    if (!isLoggedIn) {
      if (redirectIfLoggedIn) {
        // 로그인 페이지에서 이미 로그인되어 있으면 /home으로 리디렉션
        Future.microtask(() {
          Navigator.pushReplacementNamed(context, '/home');
        });

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // 다른 페이지에서는 /login으로 리디렉션
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (redirectIfLoggedIn && isLoggedIn) {
      // 로그인 페이지에서 이미 로그인된 경우
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/home');
      });

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return child;
  }
}
