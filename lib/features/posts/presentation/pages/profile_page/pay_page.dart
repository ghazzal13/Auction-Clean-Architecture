import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  var url;
  @override
  void initState() {
    super.initState();
    url = 'http://127.0.0.1:8000/pay';
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
          onPageFinished: (Page) {},
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: url),
    );
  }
}
