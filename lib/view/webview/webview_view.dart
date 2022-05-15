import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewView extends StatefulWidget {
  const WebViewView({Key? key}) : super(key: key);

  @override
  State<WebViewView> createState() => _WebViewViewState();
}

class _WebViewViewState extends State<WebViewView> {
  final _controller = Completer<WebViewController>();
  int _loadingPercentage = 0;
  String _currentUrl = "https://panlasangpinoy.com";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          _currentUrl,
          style: const TextStyle(color: Colors.black, fontSize: 12.0),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          NavigationControls(controller: _controller),
        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: "https://panlasangpinoy.com",
            onWebViewCreated: (webViewController) {
              _controller.complete(webViewController);
            },
            onPageStarted: (url) {
              setState(() {
                _loadingPercentage = 0;
              });
            },
            onProgress: (progress) {
              setState(() {
                _loadingPercentage = progress;
              });
            },
            onPageFinished: (url) {
              setState(() {
                _loadingPercentage = 100;
              });
            },
            navigationDelegate: (navigation) {
              setState(() {
                _currentUrl = navigation.url;
              });
              return NavigationDecision.navigate;
            },
          ),
          if (_loadingPercentage < 100)
            LinearProgressIndicator(
              value: _loadingPercentage / 100.0,
              color: Colors.red,
              backgroundColor: Colors.blue,
            ),
        ],
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, Key? key})
      : super(key: key);

  final Completer<WebViewController> controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller.future,
      builder: (context, snapshot) {
        final WebViewController? controller = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done ||
            controller == null) {
          return const SizedBox();
        }
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No back history item')),
                  );
                  return;
                }
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
              onPressed: () async {
                if (await controller.canGoForward()) {
                  await controller.goForward();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No forward history item')),
                  );
                  return;
                }
              },
            ),
          ],
        );
      },
    );
  }
}
