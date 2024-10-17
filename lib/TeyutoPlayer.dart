import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TeyutoPlayer extends StatefulWidget {
  final Map<String, dynamic> obj;
  final Function? onPlay;
  final Function? onPause;
  final Function? onTimeUpdate;
  final Function? onVolumeChange;

  const TeyutoPlayer({
    required this.obj,
    this.onPlay,
    this.onPause,
    this.onTimeUpdate,
    this.onVolumeChange,
    Key? key,
  }) : super(key: key);

  @override
  TeyutoPlayerState createState() => TeyutoPlayerState();
}

class TeyutoPlayerState extends State<TeyutoPlayer> {
  InAppWebViewController? _webViewController;
  Map<String, double> TeyutoPlayerCurrentTimeValue = {};
  Map<String, double> TeyutoPlayerCurrentVolumeValue = {};

  InAppWebViewSettings settings = InAppWebViewSettings(
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllowFullscreen: true);

  @override
  void initState() {
    super.initState();
    if (widget.obj['channel'] == null) {
      print("Missing channel header");
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          const Duration(milliseconds: 500), () => _initializePlayer());
    });
  }

  void _initializePlayer() {
    String idVideo = widget.obj['id'];
    String channel = widget.obj['channel'];
    Map<String, dynamic> options = widget.obj['options'] ?? {};

    Map<String, String> defaults = {
      'height': '315',
      'width': '560',
      'autoplay': 'on',
      'muted': 'off',
      'controls': 'on',
      'playbackRates': 'on',
      'qualitySelector': 'on',
      'playerColor': '',
      'loop': 'off',
      'captions': 'on',
      'pip': 'off',
      'seekButtons': 'off',
      'lowLatency': 'off',
      'related': '',
      'relatedTags': '',
      'adTag': '',
      'token': ''
    };

    final finalOptions = {...defaults, ...options};
    String urlIframe =
        "https://teyuto.tv/video/player?w=$idVideo&cid=$channel&token=${finalOptions['token']}&auto=${finalOptions['autoplay']}&muted=${finalOptions['muted']}&controls=${finalOptions['controls']}&playbackRates=${finalOptions['playbackRates']}&qualitySelector=${finalOptions['qualitySelector']}&playerColor=${finalOptions['playerColor']}&loop=${finalOptions['loop']}&captions=${finalOptions['captions']}&seekButtons=${finalOptions['seekButtons']}&lowLatency=${finalOptions['lowLatency']}&related=${finalOptions['related']}&relatedTags=${finalOptions['relatedTags']}&adTag=${finalOptions['adTag']}";

    setState(() {
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(urlIframe)));
    });
  }

  void _handleMessage(List<dynamic> message) {
    if (message.isNotEmpty) {
      Map<String, dynamic> data = message[0] as Map<String, dynamic>;
      switch (data['type']) {
        case 'timeupdate':
          if (widget.onTimeUpdate != null) {
            widget.onTimeUpdate!(data['values']['time']);
          }
          break;
        case 'currentTime':
          setState(() {
            TeyutoPlayerCurrentTimeValue[data['idVideo']] = data['value'];
          });
          if (widget.onTimeUpdate != null) widget.onTimeUpdate!(data['value']);
          break;
        case 'volume':
          setState(() {
            TeyutoPlayerCurrentVolumeValue[data['idVideo']] = data['value'];
          });
          if (widget.onVolumeChange != null)
            widget.onVolumeChange!(data['value']);
          break;
        case 'play':
          if (widget.onPlay != null) widget.onPlay!();
          break;
        case 'pause':
          if (widget.onPause != null) widget.onPause!();
          break;
        default:
          break;
      }
    }
  }

  // Metodd
  Future<void> play() async {
    await _webViewController?.evaluateJavascript(source: '''
      window.postMessage({function: "play"}, "*");
    ''');
  }

  Future<void> pause() async {
    await _webViewController?.evaluateJavascript(source: '''
      window.postMessage({function: "pause"}, "*");
    ''');
  }

  Future<double?> getCurrentTime() async {
    return TeyutoPlayerCurrentTimeValue[widget.obj['id']];
  }

  Future<void> setCurrentTime(double time) async {
    await _webViewController?.evaluateJavascript(source: '''
      window.postMessage({function: "setCurrentTime", param: $time}, "*");
    ''');
  }

  Future<void> mute() async {
    await _webViewController?.evaluateJavascript(source: '''
      window.postMessage({function: "mute"}, "*");
    ''');
  }

  Future<void> unmute() async {
    await _webViewController?.evaluateJavascript(source: '''
      window.postMessage({function: "unmute"}, "*");
    ''');
  }

  Future<void> setVolume(double volume) async {
    await _webViewController?.evaluateJavascript(source: '''
      window.postMessage({function: "setVolume", param: $volume}, "*");
    ''');
  }

  Future<double?> getVolume() async {
    return TeyutoPlayerCurrentVolumeValue[widget.obj['id']];
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialSettings: settings,
      initialUrlRequest: URLRequest(url: WebUri('about:blank')),
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onLoadError: (controller, url, code, message) {
        print("onLoadError: $message");
      },
      onLoadStop: (controller, url) {
        controller.addJavaScriptHandler(
            handlerName: 'messageHandler',
            callback: (args) {
              _handleMessage(args);
            });
        //_initializePlayer();
        controller.evaluateJavascript(source: '''
          window.addEventListener("message", (event) => {
            window.flutter_inappwebview.callHandler('messageHandler', JSON.parse(event.data));
          }, false);
        ''');
      },
    );
  }
}
