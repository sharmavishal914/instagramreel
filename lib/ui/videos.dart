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

class _ReelsState extends State<Reels> {
  int _currentPage = 0;
  List<String> videoUrls = [];
  final int _threshold = 2;
  late PreloadPageController _pageController;

  // @override
  // void initState() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  //   _pageController = PreloadPageController(initialPage: 0);
  //   videoUrls = [
  //     'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
  //     'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
  //     'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
  //   ];
  //   super.initState();
  // }
  //
  // void _loadMoreVideos() {
  //   List<String> moreVideos = [
  //     'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
  //     'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
  //     'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
  //   ];
  //   setState(() {
  //     videoUrls.addAll(moreVideos);
  //   });
  // }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _pageController = PreloadPageController(initialPage: 0);
    videoUrls = [
      'https://flipfit-cdn.akamaized.net/flip_hls/661f570aab9d840019942b80-473e0b/video_h1.m3u8',
      'https://cdn.pixabay.com/video/2022/07/24/125314-733046618_tiny.mp4',
      'https://cdn.pixabay.com/video/2022/09/19/131824-751934493_tiny.mp4',
      'https://cdn.pixabay.com/video/2022/10/04/133507-756991150_tiny.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    ];
    super.initState();
  }

  void _loadMoreVideos() {
    List<String> moreVideos = [
      'https://cdn.pixabay.com/video/2021/08/13/84878-588566505_tiny.mp4',
      'https://cdn.pixabay.com/video/2023/03/15/154787-808530571_tiny.mp4',
      'https://cdn.pixabay.com/video/2022/07/24/125314-733046618_tiny.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    ];
    setState(() {
      videoUrls.addAll(moreVideos);
    });
  }

  Positioned buildPosLikeComment() {
    return Positioned(
        bottom: 100,
        right: 10,
        width: 50,
        height: 260,
        child: likeShareCommentSave());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PreloadPageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: videoUrls.length,
        onPageChanged: (value) {
          setState(() {
            _currentPage = value;
            if (value >= videoUrls.length - _threshold) {
              _loadMoreVideos();
            }
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Container(color: Colors.black),
              Center(
                child: Videoplayer(
                  isActive: index == _currentPage, // Only active page plays
                  url: videoUrls[index],
                ),
              ),
              const CommentWithPublisher(),
              buildPosLikeComment(),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }
}
