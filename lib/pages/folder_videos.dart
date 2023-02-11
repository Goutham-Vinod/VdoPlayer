import 'package:vdo_player/common.dart';
import 'package:flutter/material.dart';
import 'package:vdo_player/components/grid_list_view_videos_widget.dart';
import 'package:vdo_player/video_preview.dart';
import 'package:vdo_player/components/common_functions.dart';
import 'package:vdo_player/components/sort_popup_button.dart';

class FolderVideos extends StatefulWidget {
  const FolderVideos({super.key});

  @override
  State<FolderVideos> createState() => _FolderVideosState();
}

class _FolderVideosState extends State<FolderVideos> {
  List videos = [];
  List videosGlobalBackup = [];
  bool searchTextControllerVisibility = false;
  final _searchTextController = TextEditingController();
  @override
  void initState() {
    videosGlobalBackup = videosGlobalNotifier.value;
    super.initState();
  }

  @override
  void dispose() {
    videosGlobalNotifier.value = videosGlobalBackup;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${findFolderName(selectedFolderPath)}"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    gridViewStateNotifierGlobal.value == 1
                        ? gridViewStateNotifierGlobal.value = 0
                        : gridViewStateNotifierGlobal.value = 1;
                  });
                },
                icon: gridViewStateNotifierGlobal.value == 1
                    ? const Icon(Icons.list)
                    : const Icon(Icons.grid_view_outlined)),
            sortPopupButton(context),
            IconButton(
                onPressed: () {
                  setState(() {
                    searchTextControllerVisibility = true;
                  });
                },
                icon: const Icon(Icons.search)),
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: videosGlobalNotifier,
            builder: (context, videosGlobal, child) {
              videos = findUniqueFiles(
                  searchFromStringList(selectedFolderPath, videosGlobal));
              return Column(
                children: [
                  Visibility(
                    visible: searchTextControllerVisibility,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _searchTextController,
                        onChanged: (value) {
                          if (videosGlobalBackup.isEmpty) {
                            videosGlobalBackup = videosGlobalNotifier.value;
                          }

                          videosGlobalNotifier.value =
                              searchFromStringList(value, videosGlobalBackup);

                          if (value == "") {
                            videosGlobalNotifier.value = videosGlobalBackup;
                          }
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Search',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  searchTextControllerVisibility = false;
                                  videosGlobalNotifier.value =
                                      videosGlobalBackup;
                                });
                              },
                              icon: const Icon(Icons.clear)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: GridListViewVideosWidget(
                    dataList: videos,
                    thumbnailImage:
                        Image.asset("assets/video_thumbnail_icon.png"),
                    onTapFunction: (index) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return VideoPreview(videos[index]);
                      }));
                    },
                    enableThreeDot: true,
                    enableDeleteAtThreeDot: false,
                  ))
                ],
              );
            }));
  }
}
