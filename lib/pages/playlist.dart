import 'package:flutter/material.dart';
import 'package:vdo_player/db/db_functions.dart';
import 'package:vdo_player/pages/playlist_videos.dart';
import 'package:vdo_player/components/common_functions.dart';
import 'package:vdo_player/common.dart';

class Playlist extends StatefulWidget {
  Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  List videos = videosGlobalNotifier.value;
  List playlistModelVarList = [];
  final _listKey = GlobalKey();
  double userTapPosX = 0;
  double userTapPosY = 0;

  @override
  void initState() {
    playlistModelVarList = playlistFolderNotifier.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: playlistFolderNotifier,
        builder: (context, playlistFolder, child) {
          return ValueListenableBuilder(
              valueListenable: gridViewStateNotifierGlobal,
              builder: (context, gridViewState, child) {
                return gridViewState == 1
                    ? GridView.builder(
                        itemCount: playlistFolder.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, crossAxisSpacing: 1),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTapDown: (details) {
                              setState(() {
                                userTapPosX = details.globalPosition.dx;
                                userTapPosY = details.globalPosition.dy;
                              });
                            },
                            onLongPress: () {
                              showPopUpMenu(context, playlistFolder[index].id,
                                  userTapPosX, userTapPosY);
                            },
                            onTap: () {
                              selectedPlaylistFolderIndex = index;
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (ctx) {
                                return const PlaylistVideos();
                              }));
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Image.asset(
                                    "assets/playlist_thumbnail_icon.png",
                                    height: 50,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 67,
                                  child: Text(
                                    truncateWithEllipsis(
                                        25, playlistFolder[index].playlistName),
                                    style: const TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          );
                        })
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ListView.separated(
                            key: _listKey,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTapDown: (details) {
                                  setState(() {
                                    userTapPosX = details.globalPosition.dx;
                                    userTapPosY = details.globalPosition.dy;
                                  });
                                },
                                onLongPress: () {
                                  showPopUpMenu(
                                      context,
                                      playlistFolder[index].id,
                                      userTapPosX,
                                      userTapPosY);
                                },
                                onTap: () {
                                  selectedPlaylistFolderIndex = index;
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) {
                                    return const PlaylistVideos();
                                  }));
                                },
                                child: ListTile(
                                  leading: const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Image(
                                        image: AssetImage(
                                            "assets/playlist_thumbnail_icon.png")),
                                  ),
                                  title: Text(
                                    truncateWithEllipsis(
                                        25, playlistFolder[index].playlistName),
                                  ),
                                ),
                              );
                            },
                            itemCount: playlistFolder.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(thickness: 1)),
                      );
              });
        });
  }

  void showPopUpMenu(BuildContext context, playlistId, posX, posY) {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(posX, posY, posX, posY),
        items: [
          const PopupMenuItem(value: "Delete", child: Text("Delete")),
          // const PopupMenuItem(
          //     value: "Clear Playlist", child: Text("Clear Playlist"))
        ]).then((value) {
      if (value != null) {
        if (value == "Delete") {
          if (playlistId != null && playlistId != 0) {
            // playlist id == 0 should not be deleted
            //because it will be favourites playlist
            deletePlaylist(playlistId!);
          }
          if (playlistId == 0) {
            clearVideosInPlaylist(playlistId);
          }
        }
        if (value == "Clear Playlist") {
          clearVideosInPlaylist(playlistId);
        }
      }
    });
  }
}
