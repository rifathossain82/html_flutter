import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class ShowHtmlByWebview extends StatefulWidget {
  const ShowHtmlByWebview({Key? key}) : super(key: key);

  @override
  _ShowHtmlByWebviewState createState() => _ShowHtmlByWebviewState();
}

class _ShowHtmlByWebviewState extends State<ShowHtmlByWebview> {
  late WebViewPlusController controller;

  // final html="""<div>
  //       <h1>Demo Page</h1>
  //       <p>This is a fantastic product that you should buy!</p>
  //       <h3>Features</h3>
  //       <ul>
  //         <li>It actually works</li>
  //         <li>It exists</li>
  //         <li>It doesn't cost much!</li>
  //       </ul>
  //       <!--You can pretty much put any html in here!-->
  //     </div>""";

  void loadLocalHtml() async {
    final html = await rootBundle.loadString('assets/html/index.html');
    final url = UriData.fromString(
      html,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();

    controller.loadUrl(url);
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Html Code by Webview'),
      ),
      body: WebViewPlus(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'assets/html/index.html',
        onWebViewCreated: (controller) {
          this.controller = controller;

          //loadLocalHtml();
        },
        javascriptChannels: {
          JavascriptChannel(
              name: "JavascriptChannel",
              onMessageReceived: (message) async {
                print(message.message);
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          message.message,
                          style: TextStyle(fontSize: 22),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Ok'))
                        ],
                      );
                    });
                controller.webViewController.evaluateJavascript('ok()');
              })
        },
      ),
    );
  }
}
