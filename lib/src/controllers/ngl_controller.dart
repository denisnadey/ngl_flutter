import 'dart:async';
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

class NGLViewerController {
  late WebViewController _webViewController;

  final Set<String> _channels = {};

  void attach(WebViewController controller) {
    _webViewController = controller;
  }

  Future<void> loadLigand(String ligandId) async {
    await _webViewController.runJavaScript("loadLigand('$ligandId');");
  }

  Future<void> captureImage(
      Function(String base64Image) onImageCaptured) async {
    Completer<String> completer = Completer<String>();

    if (_channels.contains('CaptureChannel')) {
      await _webViewController.runJavaScript("captureImage();");
    } else {
      _channels.add('CaptureChannel');
      await _webViewController.addJavaScriptChannel(
        'CaptureChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final response = jsonDecode(message.message);
          if (response['type'] == 'image') {
            onImageCaptured(response['data']);
            completer.complete(response['data']);
          }
        },
      );
      await _webViewController.runJavaScript("captureImage();");
    }
    await completer.future;
  }

  Future<void> reload() async {
    await _webViewController.reload();
  }
}
