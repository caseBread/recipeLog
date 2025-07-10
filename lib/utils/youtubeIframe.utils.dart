import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;
import 'package:flutter/widgets.dart';

Widget buildYoutubeIframe(String videoId) {
  final iframe = web.HTMLIFrameElement()
    ..width = '100%'
    ..height = '315'
    ..src = 'https://www.youtube.com/embed/$videoId'
    ..style.border = 'none'
    ..allowFullscreen = true;

  final viewType = 'youtube-iframe-$videoId';
  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(
    viewType,
    (int viewId) => iframe,
  );

  return HtmlElementView(viewType: viewType);
}
