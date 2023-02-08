import 'package:flutter/foundation.dart';
import 'package:vdo_player/db/db_model.dart';

//import 'package:vdo_player/common.dart';

//global variables here

// List videosGlobal = [];

final ValueNotifier<List> videosGlobalNotifier = ValueNotifier([]);

final ValueNotifier<int> selectedNaviBarIndexNotifierGlobal =
    ValueNotifier<int>(0);
final ValueNotifier<int> gridViewStateNotifierGlobal = ValueNotifier<int>(0);

String selectedFolderPath = "Default path";
int selectedPlaylistFolderIndex = 0;

ValueNotifier<List<PlaylistModel>> playlistFolderNotifier = ValueNotifier([]);
