import 'dart:async';
import 'dart:convert';

import 'package:ngl_flutter/export_file.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NGLViewerController {
  late WebViewController _webViewController;

  
  StreamController<AtomInfo> atomInfoStreamController = StreamController<AtomInfo>.broadcast();

  Stream<AtomInfo> get atomInfoStream => atomInfoStreamController.stream;

  

  /// Очередь всех ожидающих Completer-ов
  /// (каждый вызов `captureImage` создаёт свой Completer).
  final List<Completer<String>> captureRequests = [];

  void attach(WebViewController controller) {
    _webViewController = controller;
  }

  Future<void> loadLigand(String ligandId) async {
    await _webViewController.runJavaScript("loadLigand('$ligandId');");
  }

  


  /// Вызываем captureImage и, когда придёт результат из JS, вызываем [onImageCaptured].
  Future<void> captureImage(
      Function(String base64Image) onImageCaptured) async {
    // Создаём новый Completer для каждого вызова captureImage
    final completer = Completer<String>();
    captureRequests.add(completer);

    // Запускаем captureImage() на стороне WebView
    await _webViewController.runJavaScript("captureImage();");

    // Дожидаемся, пока Completer завершится (получим base64 с JS)
    final result = await completer.future;

    // Вызываем переданный колбэк
    onImageCaptured(result);
  }

  Future<void> reload() async {
    await _webViewController.reload();
  }
}
