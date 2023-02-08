import 'package:flutter/material.dart';
import 'package:vdo_player/components/grid_list_view_widget.dart';
import 'package:vdo_player/pages/folder_videos.dart';
import 'package:vdo_player/components/common_functions.dart';
import 'package:vdo_player/common.dart';

class Folders extends StatefulWidget {
  const Folders({super.key});

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  List videos = [];
  List uniqueFolders = [];
  @override
  void initState() {
    videos = videosGlobalNotifier.value;
    uniqueFolders = findUniqueFolders(videos);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridListViewWidget(
      dataList: uniqueFolders,
      thumbnailImage: Image.asset("assets/folder_thumbnail_icon.png"),
      crossAxisCount: 3,
      onTapFunction: (index) {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return const FolderVideos();
        }));
        selectedFolderPath = uniqueFolders[index];
      },
    );
  }
}
