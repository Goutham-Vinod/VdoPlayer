import 'package:flutter/material.dart';
import 'package:vdo_player/components/grid_list_view_videos_widget.dart';
import 'package:vdo_player/common.dart';
import 'package:vdo_player/components/show_snack_bar.dart';
import 'package:vdo_player/db/db_functions.dart';
import 'package:vdo_player/video_preview.dart';

class PlaylistVideos extends StatefulWidget {
  const PlaylistVideos({super.key});

  @override
  State<PlaylistVideos> createState() => _PlaylistVideosState();
}

class _PlaylistVideosState extends State<PlaylistVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "${playlistFolderNotifier.value[selectedPlaylistFolderIndex].playlistName}"),
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
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: playlistFolderNotifier,
            builder: (context, playlistFolder, child) {
              if (playlistFolder[selectedPlaylistFolderIndex].playlist !=
                  null) {
                return GridListViewVideosWidget(
                  dataList:
                      playlistFolder[selectedPlaylistFolderIndex].playlist!,
                  thumbnailImage:
                      Image.asset("assets/video_thumbnail_icon.png"),
                  onTapFunction: (index) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return VideoPreview(
                          playlistFolder[selectedPlaylistFolderIndex]
                              .playlist![index]);
                    }));
                  },
                  enableThreeDot: true,
                  enableDeleteAtThreeDot: true,
                  deleteFunction: (index) {
                    playlistFolderNotifier
                        .value[selectedPlaylistFolderIndex].playlist
                        ?.removeAt(index);
                    updatePlaylist(playlistFolderNotifier
                        .value[selectedPlaylistFolderIndex]);

                    showSnackBar(context,
                        "Video Deleted from ${playlistFolder[selectedPlaylistFolderIndex].playlistName} Playlist");
                  },
                );
              } else {
                return const Center(child: Text("No Videos"));
              }
            }));
  }
}
