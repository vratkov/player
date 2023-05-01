import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayerScreen extends StatefulWidget {
  final List<String> songPaths;

  PlayerScreen({super.key, required this.songPaths});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else if (state == PlayerState.paused) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.release();
    _audioPlayer.dispose();
  }

  void _playSong(sourcePath) async {
    await _audioPlayer.play(AssetSource(sourcePath));
  }

  void _pauseSong() async {
    await _audioPlayer.pause();
  }

  void _stopSong() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _currentIndex = 0;
    });
  }

  void _previousSong() {
    int previousIndex = _currentIndex - 1;
    if (previousIndex < 0) {
      previousIndex = widget.songPaths.length - 1;
    }
    String previousSong = widget.songPaths[previousIndex];
    setState(() {
      _currentIndex = previousIndex;
    });
    _playSong(previousSong);
  }

  void _nextSong() {
    int nextIndex = (_currentIndex + 1) % widget.songPaths.length;
    String nextSong = widget.songPaths[nextIndex];
    setState(() {
      _currentIndex = nextIndex;
    });
    _playSong(nextSong);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.songPaths[_currentIndex].split('/').last,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: _previousSong,
                ),
                IconButton(
                  icon: _isPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  onPressed: () {
                    if (_isPlaying) {
                      _pauseSong();
                    } else {
                      _playSong(widget.songPaths[_currentIndex]);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: _stopSong,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: _nextSong,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
