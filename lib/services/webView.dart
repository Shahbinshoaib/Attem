import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {

  final String url;

  const Webview({Key key, this.url}) : super(key: key);
  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://google.com',
        onWebViewCreated: (WebViewController
        webViewController ){
          _controller.complete(webViewController);
        },
      )
    );
  }
}
