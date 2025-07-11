import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:recipe_log/auth_guard.dart';
import 'package:recipe_log/pages/myrecipe_page.dart';
import 'package:recipe_log/pages/recipe_detail_page.dart';
import 'package:recipe_log/pages/search_page.dart';
import 'package:recipe_log/utils/auth.utils.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = checkIsLoggedIn();

    return MaterialApp(
      title: '레시피 노트',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/': (context) => RootPage(isLoggedIn: isLoggedIn),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/myrecipe': (context) => MyRecipePage(),
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');

        if (uri.path == '/search') {
          return MaterialPageRoute(
            builder: (context) => const SearchPage(),
            settings: settings,
          );
        }

        // ✅ /recipes/:id 처리
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'recipes') {
          final id = uri.pathSegments[1];
          return MaterialPageRoute(
            builder: (context) => RecipeDetailPage(id: id),
            settings: settings,
          );
        }

        // 알 수 없는 라우트 처리
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
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
      if (!isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
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
