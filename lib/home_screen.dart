import 'package:flutter/material.dart';
import 'package:vdo_player/components/common_functions.dart';
import 'package:vdo_player/components/create_playlist_dialogue.dart';
import 'package:vdo_player/components/dialog_box_widget.dart';
import 'package:vdo_player/components/show_snack_bar.dart';
import 'package:vdo_player/db/db_functions.dart';
import 'package:vdo_player/pages/Settings.dart';
import 'package:vdo_player/common.dart';
import 'package:vdo_player/pages/folders.dart';
import 'package:vdo_player/pages/home.dart';
import 'package:vdo_player/pages/playlist.dart';
import 'package:vdo_player/components/sort_popup_button.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentNaviIndex = 0;
  // bool appBarIconsVisibility = true;
  String appBarTitle = "Vdo Player";
  bool appBarTitleCenterToggle = false;
  bool appBarSearchIconVisibility = true;
  bool playlistPageIconVisibility = false;
  bool appBarSortIconVisibility = true;
  bool appBarGridIconVisibility = true;
  bool searchTextControllerVisibility = false;
  final _searchTextController = TextEditingController();
  List videosGlobalBackup = [];

  List pages = <Widget>[
    const Home(),
    const Folders(),
    Playlist(),
    const Settings(),
  ];

  @override
  void initState() {
    videosGlobalBackup = videosGlobalNotifier.value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedNaviBarIndexNotifierGlobal,
        builder: (context, selectedNaviBarIndex, child) {
          if (selectedNaviBarIndex < 4) {
            currentNaviIndex = selectedNaviBarIndex;
          }
          return Scaffold(
              appBar: AppBar(
                title: Text(appBarTitle),
                centerTitle: appBarTitleCenterToggle,
                actions: [
                  Visibility(
                    visible: appBarGridIconVisibility,
                    child: IconButton(
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
                  ),
                  Visibility(
                      visible: appBarSortIconVisibility,
                      child: sortPopupButton(context)),
                  Visibility(
                      visible: appBarSearchIconVisibility,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              searchTextControllerVisibility = true;
                            });
                          },
                          icon: const Icon(Icons.search))),
                  Visibility(
                      visible: playlistPageIconVisibility,
                      child: IconButton(
                          onPressed: () {
                            dialogBoxWidget(
                                context,
                                "Delete All Playlist",
                                "Are you sure you want to delete all playlist permanently?",
                                "Delete", () {
                              clearPlaylistDb();
                              showSnackBar(
                                  context, "All Playlist deleted permanently");
                              Navigator.of(context).pop();
                            });
                          },
                          icon: const Icon(Icons.delete_forever))),
                  Visibility(
                      visible: playlistPageIconVisibility,
                      child: IconButton(
                          onPressed: () {
                            showCreatePlaylistDialog(context);
                          },
                          icon: const Icon(Icons.add_box_outlined))),
                ],
              ),
              body: Column(
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
                  Expanded(child: pages[selectedNaviBarIndex])
                ],
              ),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 155, 155, 155), blurRadius: 20)
                ]),
                child: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        size: 30,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.folder,
                        size: 30,
                      ),
                      label: 'Folders',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.playlist_add,
                        size: 30,
                      ),
                      label: 'Playlist',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.settings,
                        size: 30,
                      ),
                      label: 'Settings',
                    ),
                  ],
                  currentIndex: currentNaviIndex,
                  selectedItemColor: const Color.fromARGB(250, 61, 0, 121),
                  onTap: (value) {
                    selectedNaviBarIndexNotifierGlobal.value = value;
                    setState(() {
                      switch (value) {
                        case 0:
                          appBarTitle = "Vdo Player";
                          appBarSortIconVisibility = true;
                          appBarTitleCenterToggle = false;
                          appBarSearchIconVisibility = true;
                          playlistPageIconVisibility = false;
                          appBarGridIconVisibility = true;
                          break;
                        case 1:
                          appBarTitle = "Folders";
                          appBarSortIconVisibility = false;
                          appBarTitleCenterToggle = false;
                          appBarSearchIconVisibility = false;
                          playlistPageIconVisibility = false;
                          appBarGridIconVisibility = true;
                          searchTextControllerVisibility = false;
                          videosGlobalNotifier.value = videosGlobalBackup;
                          break;
                        case 2:
                          appBarTitle = "Playlist";
                          appBarSortIconVisibility = false;
                          appBarTitleCenterToggle = false;
                          appBarSearchIconVisibility = false;
                          playlistPageIconVisibility = true;
                          appBarGridIconVisibility = true;
                          searchTextControllerVisibility = false;
                          videosGlobalNotifier.value = videosGlobalBackup;
                          break;
                        case 3:
                          appBarTitle = "Settings";
                          appBarSortIconVisibility = false;
                          appBarTitleCenterToggle = true;
                          appBarSearchIconVisibility = false;
                          playlistPageIconVisibility = false;
                          appBarGridIconVisibility = false;
                          searchTextControllerVisibility = false;
                          videosGlobalNotifier.value = videosGlobalBackup;
                          break;
                        default:
                          appBarTitle = "Vdo Player";
                      }
                    });
                  },
                ),
              ));
        });
  }
}
