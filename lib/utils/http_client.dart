// lib/utils/http_client.dart
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

http.Client createHttpClient() {
  if (kIsWeb) {
    // 웹 환경일 때 BrowserClient + withCredentials
    return BrowserClient()..withCredentials = true;
  } else {
    // 모바일/데스크톱은 기본 클라이언트
    return http.Client();
  }
}

// 앱 전체에서 이 클라이언트를 import해서 사용
final httpClient = createHttpClient();
