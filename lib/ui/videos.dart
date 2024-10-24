import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagramreel/components/mainwidget.dart';
import 'package:instagramreel/components/videoplayer.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';

class Reels extends StatefulWidget {
  const Reels({super.key});

  @override
  _ReelsState createState() => _ReelsState();
}

final videoPlayerController = VideoPlayerController.networkUrl(
    Uri.parse('https://flipfit-cdn.akamaized.net/flip_hls/661f570aab9d840019942b80-473e0b/video_h1.m3u8'));

class _ReelsState extends State<Reels> {
  @override
  void initState() {
    loadVideoClip();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Positioned buildPosLikeComment() {
      return Positioned(
          bottom: 100,
          right: 10,
          width: 50,
          height: 260,
          child: likeShareCommentSave());
    }

    return Scaffold(
      body: PreloadPageView.builder(
        scrollDirection: Axis.vertical,
        controller: PreloadPageController(),
        itemBuilder: (BuildContext context, int index) {  
       return Stack(
          children: [
            Container(color: Colors.black,),
            Videoplayer(url: 'https://flipfit-cdn.akamaized.net/flip_hls/661f570aab9d840019942b80-473e0b/video_h1.m3u8'), // Video Player
            const CommentWithPublisher(),
            buildPosLikeComment()
          ],
        );
   }, ),
    );
  }

  void loadVideoClip() async {
    await videoPlayerController.initialize();
    videoPlayerController.play();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

}