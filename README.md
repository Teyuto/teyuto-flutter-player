# Teyuto Player SDK

## Overview

The Teyuto Player SDK allows you to easily integrate the Teyuto video player into your Flutter applications. This guide provides an overview of how to set up and use the SDK in your project.

## Features

- Embed Teyuto videos into your Flutter app.
- Control playback (play, pause).
- Listen to playback events (time update, volume change).
- Customize player options.

## Installation

To use the Teyuto Player SDK, add the following dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_inappwebview: ^5.3.2
```

## Usage

### Import the Teyuto Player

First, import the necessary packages and the `TeyutoPlayer` widget:

```dart
import 'package:flutter/material.dart';
import 'TeyutoPlayer.dart';
```

### Basic Integration

Here's a basic example of how to integrate the Teyuto Player into your app:

```dart
import 'package:flutter/material.dart';
import 'TeyutoPlayer.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<TeyutoPlayerState> _teyutoPlayerKey = GlobalKey();
  bool playing = false;
  double? time;

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

  void handleTimeUpdate(double _time) {
    setState(() {
      time = _time;
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
        body: Stack(
          children: [
            Center(
              child: TeyutoPlayer(
                key: _teyutoPlayerKey,
                obj: {
                  'id': '46760',
                  'channel': '30Y8zKKY9H3IUaImUidzCqa5852a1cead3fb2b2ef79cf6baf04909',
                  'options': {'autoplay': 'on'}
                },
                onPlay: handlePlay,
                onPause: handlePause,
                onTimeUpdate: (_time) => handleTimeUpdate(_time),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playing ? "Playing" : "Pause",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  time?.toString() ?? "",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
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
```

### Player Options

You can customize the player by passing options in the `obj` parameter:

```dart
TeyutoPlayer(
  obj: {
    'id': 'VIDEO_ID',
    'channel': 'CHANNEL_ID',
    'options': {
      'autoplay': 'on',
      'muted': 'off',
      'controls': 'on',
      // Add more options as needed
    }
  },
  onPlay: handlePlay,
  onPause: handlePause,
  onTimeUpdate: (_time) => handleTimeUpdate(_time),
  onVolumeChange: (_volume) => handleVolumeChange(_volume),
)
```

### Controlling the Player

You can control the player programmatically using the provided methods:

- `play()`
- `pause()`
- `setCurrentTime(double time)`
- `mute()`
- `unmute()`
- `setVolume(double volume)`
- `getCurrentTime()`
- `getVolume()`

Example:

```dart
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
```

### Event Handling

You can handle various player events using callbacks:

```dart
TeyutoPlayer(
  obj: {
    'id': 'VIDEO_ID',
    'channel': 'CHANNEL_ID',
    'options': {
      'autoplay': 'on',
    }
  },
  onPlay: () {
    print("Video is playing");
  },
  onPause: () {
    print("Video is paused");
  },
  onTimeUpdate: (double time) {
    print("Current time: $time");
  },
  onVolumeChange: (double volume) {
    print("Current volume: $volume");
  },
)
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any issues or questions, please contact [support@teyuto.com](mailto:support@teyuto.com).
