import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  void _initPlayer() async {
    videoPlayerController = VideoPlayerController.network(
        'https://bucketsawstest.s3.us-west-1.amazonaws.com/tutorial/qaidatutorial.mp4');
    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {
      _isVideoInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isVideoInitialized
        ? Chewie(
            controller: chewieController,
          )
        : Center(child: CircularProgressIndicator());
  }
}
