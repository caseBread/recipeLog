import 'package:web/web.dart' as web;

bool checkIsLoggedIn() {
  final cookies = web.document.cookie ?? '';
  // cookies 문자열 예: "access_token=abc123; another_key=value;"

  // access_token 찾기
  final regex = RegExp(r'access_token=([^;]+)');
  final match = regex.firstMatch(cookies);

  if (match != null && match.group(1) != null && match.group(1)!.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}
