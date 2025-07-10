import 'package:flutter/material.dart';
import 'package:recipe_log/widgets/common_bottom_nav.dart';

class MyRecipePage extends StatelessWidget {
  const MyRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('나의 레시피')),
      body: const Center(child: Text('나의 레시피 페이지 내용')),
      bottomNavigationBar: const CommonBottomNav(currentIndex: 2),
    );
  }
}
