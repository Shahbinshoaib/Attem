
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dart:async';


class DetailScreen extends StatefulWidget {
  final String book;
  DetailScreen({this.book});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  

  @override
  Widget build(BuildContext context) {

    final Completer<WebViewController> _controller =
    Completer<WebViewController>();
    print(widget.book);


    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: WebView(
            gestureNavigationEnabled: true,
            initialUrl: widget.book,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController
            webViewController ){
              SystemChrome.setEnabledSystemUIOverlays ([]);
              _controller.complete(webViewController);
            },
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
          child: Container(
            alignment: Alignment.topRight,
            child: ButtonTheme(
              height: 40,
              minWidth: 140,
              child: RaisedButton(
                elevation: 0,
                color: Color(0xFF1a1aff),
                child: Text('Attem',style: TextStyle(color: Colors.white, fontFamily: 'Oxanium', fontWeight: FontWeight.bold ), textAlign: TextAlign.end,),
                onPressed: (){},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
