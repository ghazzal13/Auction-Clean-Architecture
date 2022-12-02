import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String url;
  const WebPage({super.key, required this.url});

  @override
  State<WebPage> createState() => _WebPageState(url: url);
}

class _WebPageState extends State<WebPage> {
  String url;
  _WebPageState({required this.url});
  @override
  var gitHub_url = " https://github.com/ghazzal13";
  var linkedin_url = "https://www.linkedin.com/in/ahmed-ghazzal-86799b1bb/";
  late String initialUrl;
  @override
  void initState() {
    if (url == 'github') {
      initialUrl = gitHub_url;
    } else {
      initialUrl = linkedin_url;
    }

    super.initState();

    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: true,
      ),
      body: WebView(
          onPageFinished: (Page) {},
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: initialUrl),
    );
  }
}
