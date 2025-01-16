import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Videoplayer extends StatefulWidget {
  const Videoplayer({super.key, required this.url, required this.isActive});
  final bool isActive;
  final String url;

  @override
  _VideoplayerState createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Videoplayer> {
  late VideoPlayerController controller;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    try {
      await controller.initialize();
      setState(() {
        _isControllerInitialized = true;
      });

      controller.addListener(() {
        if (controller.value.position == controller.value.duration &&
            controller.value.isCompleted &&
            _isControllerInitialized) {
          controller.seekTo(Duration.zero); // Restart video when it ends
          controller.play(); // Auto-play after restarting
        }
      });

      if (widget.isActive) {
        controller.play(); // Play video if it's active
      }
    } catch (error) {
      print("Error initializing video: $error");
    }
  }

  @override
  void didUpdateWidget(covariant Videoplayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        controller.play(); // Play the video if it becomes active
      } else {
        controller.pause(); // Pause the video if it is not active
      }
    }
  }

  @override
  void dispose() {
    controller.pause(); // Pause the video when the widget is disposed
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return VisibilityDetector(
      key: Key(widget.url),
      onVisibilityChanged: (visibilityInfo) {
        var visibilityPercentage = visibilityInfo.visibleFraction * 100;
        if (visibilityPercentage > 50 && _isControllerInitialized && widget.isActive) {
          controller.play(); // Play when more than 50% of the video is visible
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          });
        },
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
