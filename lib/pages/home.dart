import 'package:flutter/material.dart';
import 'package:vdo_player/common.dart';
import 'package:vdo_player/components/grid_list_view_widget.dart';
import 'package:vdo_player/video_preview.dart';

import 'package:vdo_player/components/common_functions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List videos = [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: videosGlobalNotifier,
        builder: (context, videosGlobal, child) {
          videos = findUniqueFiles(videosGlobalNotifier.value);
          return GridListViewWidget(
            dataList: videos,
            thumbnailImage: Image.asset("assets/video_thumbnail_icon.png"),
            onTapFunction: (index) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return VideoPreview(videos[index]);
              }));
            },
            enableThreeDot: true,
          );
        });
  }
}
