import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Videoplayer extends StatefulWidget {
  const Videoplayer({super.key, required this.url});
  final String url;
  @override
  _VideoplayerState createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Videoplayer> {
  late VideoPlayerController controller;
  bool _iscontrollerinitialised = false;
  @override
  void initState() {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> initializeplayer() async {
    await controller.initialize().then((_) {
      setState(() {
        _iscontrollerinitialised = true;
      });
      controller.addListener(() {
        if (controller.value.position == controller.value.duration &&
            controller.value.isCompleted &&
            _iscontrollerinitialised) {
          controller.seekTo(Duration.zero);
          controller.play();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(widget.url),
        onVisibilityChanged: (visibilityInfo) {
          var visibilitypercentage = visibilityInfo.visibleFraction * 100;
          if (visibilitypercentage > 50 && _iscontrollerinitialised) {
            controller.play;
          }
        },
        child: GestureDetector(
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
        ));
  }
}
