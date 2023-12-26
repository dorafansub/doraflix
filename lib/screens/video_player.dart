 import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String tenPhim;
  final String soTap;

  VideoPlayerWidget({
    required this.videoUrl,
    required this.tenPhim,
    required this.soTap,
  });
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    // Initialize video player controller
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9, // Set the aspect ratio of your video
      autoInitialize: true,
      looping: true, // Set to true if you want the video to loop
      autoPlay: true, // Set to false if you don't want the video to play automatically
      allowFullScreen: true, // Disable full-screen button
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
     title: Text('${widget.tenPhim} - ${widget.soTap}'),
          backgroundColor: Colors.grey,
      ),
    body: Container(
        color: Colors.black, // Set the background color to black
        child: Center(
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}







