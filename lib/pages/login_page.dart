import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_log/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _kakaoLogin() async {
    final baseUrl = BASE_URL;
    final currentUrl = Uri.encodeComponent(web.window.location.href);
    final callbackUrl = '$baseUrl/auth/kakao/login?redirect=$currentUrl';
    final Uri url = Uri.parse(callbackUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $callbackUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth < 400 ? double.infinity : 400.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/recipe-note-logo.svg',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 32),
                const Text(
                  '레시피 노트',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  '요리 영상에\n나만의 레시피를 기록하자',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: buttonWidth,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _kakaoLogin,
                    icon: SvgPicture.asset(
                      'assets/images/ic-logo-kakao.svg',
                      width: 24,
                      height: 24,
                    ),
                    label: const Text(
                      '카카오로 시작하기',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE812),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
