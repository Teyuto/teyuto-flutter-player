import 'package:flutter/material.dart';
import 'TeyutoPlayer.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<TeyutoPlayerState> _teyutoPlayerKey = GlobalKey();
  bool playing = false;

  void handlePlay() {
    print("Video is playing");
    setState(() {
      playing = true;
    });
  }

  void handlePause() {
    print("Video is paused");
    setState(() {
      playing = false;
    });
  }

  void goToTime(double time) async {
    final TeyutoPlayerState? playerState = _teyutoPlayerKey.currentState;
    if (playerState != null) {
      await playerState.setCurrentTime(time);
    }
  }

  void playPlayer() {
    final TeyutoPlayerState? playerState = _teyutoPlayerKey.currentState;
    if (playerState != null) {
      playerState.play();
      setState(() {
        playing = true;
      });
    }
  }

  void pausePlayer() {
    final TeyutoPlayerState? playerState = _teyutoPlayerKey.currentState;
    if (playerState != null) {
      playerState.pause();
      setState(() {
        playing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Teyuto Player SDK Example'),
        ),
        body: Center(
          child: TeyutoPlayer(
            key: _teyutoPlayerKey,
            obj: {
              'id': '46760',
              'channel':
                  '30Y8zKKY9H3IUaImUidzCqa5852a1cead3fb2b2ef79cf6baf04909',
              'options': {'autoplay': 'on'}
            },
            onPlay: handlePlay,
            onPause: handlePause,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            handleFloatingActionButtonTap();
          },
          child: playing ? Icon(Icons.pause_circle) : Icon(Icons.play_arrow),
        ),
      ),
    );
  }

  void handleFloatingActionButtonTap() {
    if (playing) {
      pausePlayer();
    } else {
      playPlayer();
    }
  }
}

void main() {
  runApp(MyApp());
}
