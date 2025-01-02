import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ngl_flutter/export_file.dart';
import 'package:ngl_flutter/src/controllers/ngl_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class NGLViewerWidget extends StatefulWidget {
  final String ligandId;
  final NGLViewerController? controller;
  const NGLViewerWidget({super.key, required this.ligandId, this.controller});

  @override
  State<NGLViewerWidget> createState() => _NGLViewerWidgetState();
}

class _NGLViewerWidgetState extends State<NGLViewerWidget> {
  late WebViewController _controller;
  late NGLViewerController _nglController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _nglController = widget.controller ?? NGLViewerController();
    // Создаем параметры контроллера
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    // Создаем WebViewController
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    // Настройки для Android
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(false);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('packages/ngl_flutter/assets/ngl_viewer/index.html')
      ..setOnConsoleMessage((JavaScriptConsoleMessage consoleMessage) {
        debugPrint('JS Console: ${consoleMessage.message}');
      })
      ..addJavaScriptChannel(
        'DebugChannel',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint(message.message);
        },
      )
      ..addJavaScriptChannel(
        'CaptureChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final response = jsonDecode(message.message);

          // Допустим, наша JS-часть отправляет объекты вида:
          // { "type": "image", "data": "BASE64..." }
          if (response['type'] == 'image' &&
              _nglController.captureRequests.isNotEmpty) {
            // Забираем первый «ожидающий» Completer и завершаем его
            final requestCompleter = _nglController.captureRequests.removeAt(0);

            final base64Image = response['data'] as String;

            // завершаем Completer
            if (!requestCompleter.isCompleted) {
              requestCompleter.complete(base64Image);
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Страница загружается: $url');
          },
          onWebResourceError: (_) => _showErrorDialog(),
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            _nglController.attach(_controller);
            _nglController.loadLigand(widget.ligandId);
          },
        ),
      );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to load the ligand. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: _controller,
          gestureRecognizers: {}..add(Factory<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
            )),
        ),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
