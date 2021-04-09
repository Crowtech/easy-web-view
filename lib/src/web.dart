import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'impl.dart';

class EasyWebView extends StatefulWidget implements EasyWebViewImpl {
  const EasyWebView({
    Key? key,
    required this.src,
    required this.onLoaded,
    this.height,
    this.width,
    this.webAllowFullScreen = true,
    this.headers = const {},
    this.widgetsTextSelectable = false, 
    required this.onMessageReceived,
  })  : super(key: key);

  @override
  _EasyWebViewState createState() => _EasyWebViewState();

  @override
  final double? height;

  @override
  final String src;

  @override
  final double? width;

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
  void initState() {
    widget.onLoaded();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final _iframe = _iframeElementMap[widget.key!];
      if (_iframe != null) {
        _iframe.onLoad.listen((event) {
          widget.onLoaded();
        });
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(EasyWebView oldWidget) {
    if (oldWidget.height != widget.height) {
      if (mounted) setState(() {});
    }
    if (oldWidget.width != widget.width) {
      if (mounted) setState(() {});
    }
    if (oldWidget.src != widget.src) {
      if (mounted) setState(() {});
    }
    if (oldWidget.headers != widget.headers) {
      if (mounted) setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return OptionalSizedChild(
      width: widget.width,
      height: widget.height,
      builder: (w, h) {
        String src = widget.src;
        
        _setup(src, w, h);
        return AbsorbPointer(
          child: RepaintBoundary(
            child: HtmlElementView(
              key: widget.key,
              viewType: 'iframe-$src',
            ),
          ),
        );
      },
    );
  }

  static final _iframeElementMap = Map<Key, html.IFrameElement>();

  void _setup(String src, double? width, double? height) {
    final src = widget.src;
    final key = widget.key ?? ValueKey('');
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('iframe-$src', (int viewId) {
      if (_iframeElementMap[key] == null) {
        _iframeElementMap[key] = html.IFrameElement();
        html.window.onMessage.forEach((element) {

          JavascriptMessage message = new JavascriptMessage(element.data);
          widget.onMessageReceived(message);
          
        });
      }
      final element = _iframeElementMap[key]!
        ..style.border = '0'
        ..allowFullscreen = widget.webAllowFullScreen
        ..height = height?.toInt().toString()
        ..width = width?.toInt().toString();
      String _src = src;
     
      element..src = _src;
      return element;
    });
  }
}
