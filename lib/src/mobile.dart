import 'package:flutter/material.dart';
import 'package:flutter_nest/flutter_nest.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'impl.dart';

class EasyWebView extends StatefulWidget implements EasyWebViewImpl {

  const EasyWebView({
    @required this.src,
    @required this.onLoaded,
    Key key,
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
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (NestInfo.getPlatform() == Platform.android) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void didUpdateWidget(EasyWebView oldWidget) {
    if (oldWidget.src != widget.src) {
      _controller.loadUrl(_updateUrl(widget.src), headers: widget.headers);
    }
    if (oldWidget.height != widget.height) {
      if (mounted) setState(() {});
    }
    if (oldWidget.width != widget.width) {
      if (mounted) setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  String _updateUrl(String url) {
    String _src = url;
    widget.onLoaded();
    return _src;
  }

  @override
  Widget build(BuildContext context) {
    return OptionalSizedChild(
      width: widget.width,
      height: widget.height,
      builder: (w, h) {
        String src = widget.src;
        
        return WebView(
          key: widget.key,
          initialUrl: _updateUrl(src),
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: Set.from([JavascriptChannel(name: "Print", onMessageReceived: widget.onMessageReceived)]),
          onWebViewCreated: (val) {
            _controller = val;
            widget.onLoaded();
          },
        );
      },
    );
  }
}
