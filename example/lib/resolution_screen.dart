import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  int _selectedQuality = 0;

  // Define your video URLs for different qualities
  final List<String> _videoUrls = [
    "https://player.vimeo.com/progressive_redirect/playback/670821472/rendition/360p/file.mp4?loc=external&oauth2_token_id=1775929170&signature=7acad6926d76a71d13553023c9c943ed67df86e56ddfaa0c6c7bec4097be40a2",
    "https://player.vimeo.com/progressive_redirect/playback/670821472/rendition/720p/file.mp4?loc=external&oauth2_token_id=1775929170&signature=c610af4a4e204ad685c88de2c99c283f57a1088a564aae53570ea31d0fcbdd0e",
    "https://player.vimeo.com/progressive_redirect/playback/670821472/rendition/1080p/file.mp4?loc=external&oauth2_token_id=1775929170&signature=3dea54cae4fb9b1c0c9d6185a350d84a725f98cb1a78deeb874a5fd9f38042ec",
  ];

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = VideoPlayerController.network(_videoUrls[_selectedQuality])
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  void _changeQuality(int index) {
    setState(() {
      _selectedQuality = index;
      _controller.pause();
      _controller.dispose();
      _initializePlayer();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _videoUrls.length,
              (index) => ElevatedButton(
                onPressed: () => _changeQuality(index),
                child: Text('${[360, 720, 1080][index]}p'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
