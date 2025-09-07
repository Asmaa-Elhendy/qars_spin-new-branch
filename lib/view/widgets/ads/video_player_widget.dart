import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final bool autoPlay;
  final bool looping;

  const VideoPlayerWidget({
    Key? key,
    required this.videoPath,
    this.autoPlay = true,//jنsd
    this.looping = false,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.videoPath),
    );

    await _videoPlayerController.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      placeholder: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (widget.videoPath.isEmpty) {
      return Container(
        color: Colors.black26,
        child: const Center(
          child: Icon(
            Icons.video_library,
            size: 50,
            color: Colors.white70,
          ),
        ),
      );
    }

    return Chewie(
      controller: _chewieController!,
    );
  }
}
