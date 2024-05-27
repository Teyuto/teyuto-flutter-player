[![badge](https://img.shields.io/twitter/follow/teyuto?style=social)](https://twitter.com/intent/follow?screen_name=teyuto) &nbsp; [![badge](https://img.shields.io/github/stars/Teyuto/teyuto-player-sdk?style=social)](https://github.com/Teyuto/teyuto-player-sdk)
![](https://github.com/Teyuto/.github/blob/production/assets/img/banner.png)
<h1 align="center">Teyuto Player SDK for Flutter</h1>

[Teyuto](https://teyuto.com) provides a seamless solution for managing all your video distribution needs. Whether you require video distribution in the cloud, on OTT platforms, storage, public OTT platform distribution, or secure intranet distribution, Teyuto puts everything at your fingertips, making the management of your video content effortless.

`Teyuto Flutter Player` is a Flutter library that allows you to embed a Teyuto Video Player in a Flutter app.

## Getting Started

This package allows you to embed and control Teyuto videos within your Flutter application. It provides functionalities such as play, pause, seek, and volume control, along with event listeners for playback updates.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  teyuto_player: ^1.0.1
```

Then run the following command:

```bash
flutter pub get
```

## Usage

### Basic Integration

Import the package in your Dart file:

```dart
import 'package:teyuto_player/TeyutoPlayer.dart';
```

Use the `TeyutoPlayer` widget in your widget tree:

```dart
import 'package:flutter/material.dart';
import 'package:teyuto_player/TeyutoPlayer.dart';

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

Customize the player by passing options in the `obj` parameter:

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

### Controlling the Player

Programmatically control the player using the provided methods:

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

Handle various player events using callbacks:

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

## Additional Information

For more information, visit the [pub.dev page for Teyuto Player](https://pub.dev/publishers/teyuto.com/packages).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any issues or questions, please contact [support@teyuto.com](mailto:support@teyuto.com).