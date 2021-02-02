import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'user.dart';

class BillScreen extends StatefulWidget {
  final User user;
  final String val;

  const BillScreen({Key key, this.user, this.val}) : super(key: key);
  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                onPressed: () {
                  _backToMenu();
                },
              )
            ],
            automaticallyImplyLeading: false,
            title: Text('Your Bill'),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: WebView(
                  initialUrl:
                      'http://steadybongbibi.com/techcomm/php/generate_bill.php?email=' +
                          widget.user.email +
                          '&mobile=' +
                          widget.user.phone +
                          '&name=' +
                          widget.user.name +
                          '&amount=' +
                          widget.val,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
            ],
          )),
    );
  }

  void _backToMenu() {
    Navigator.pop(context);
    Navigator.of(context).pop(true);
  }
}
