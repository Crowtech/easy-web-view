import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'impl.dart';

class EasyWebView extends StatefulWidget implements EasyWebViewImpl {

  const EasyWebView({
    Key key,
    @required this.src,
    @required this.onLoaded,
    this.height,
    this.width,
    this.webAllowFullScreen = true,
    this.headers = const {},
    this.widgetsTextSelectable = false,
    @required this.onMessageReceived,
  })  : super(key: key);

  @override
  _EasyWebViewState createState() => _EasyWebViewState();

  @override
  final double height;

  @override
  final String src;

  @override
  final double width;

  @override
  final bool webAllowFullScreen;

  @override
  final Map<String, String> headers;

  @override
  final bool widgetsTextSelectable;

  @override
  final void Function() onLoaded;

  @override
  final void Function(JavascriptMessage) onMessageReceived;
}
  

class _EasyWebViewState extends State<EasyWebView> {
  @override
  Widget build(BuildContext context) {
    return OptionalSizedChild(
      width: widget.width,
      height: widget.height,
      builder: (w, h) => Placeholder(),
    );
  }
}
