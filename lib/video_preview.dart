import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class VideoPreview extends StatefulWidget {
  VideoPreview(this.videoPath, {super.key});

  String videoPath;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController videoPlayerController;
  late FlickManager flickManager;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    flickManager = FlickManager(
      videoPlayerController: videoPlayerController,
    );

    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: const FlickVideoWithControls(
                controls: FlickPortraitControls(),
                videoFit: BoxFit.contain,
              ),
              flickVideoWithControlsFullscreen: const FlickVideoWithControls(
                controls: FlickLandscapeControls(),
                videoFit: BoxFit.contain,
              ),
              wakelockEnabled: true,
              preferredDeviceOrientation: const [
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft
              ]),
          Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }
}
