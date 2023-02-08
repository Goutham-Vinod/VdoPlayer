import 'package:vdo_player/db/db_model.dart';
import 'package:hive/hive.dart';
import 'package:vdo_player/common.dart';

Future<void> addPlaylist(PlaylistModel value) async {
  final videoDB = await Hive.openBox<PlaylistModel>('video_db');
  final id = await videoDB.add(value);
  value.id = id;

  await videoDB.put(id, value);
  getAllPlaylist();
  //videoListNotifier.value.add(value);
  //videoListNotifier.notifyListeners();
}

Future<void> getAllPlaylist() async {
  final videoDB = await Hive.openBox<PlaylistModel>('video_db');
  playlistFolderNotifier.value.clear();
  playlistFolderNotifier.value.addAll(videoDB.values);
  playlistFolderNotifier.notifyListeners();
}

Future<void> deletePlaylist(int id) async {
  final videoDB = await Hive.openBox<PlaylistModel>('video_db');
  await videoDB.delete(id);
  getAllPlaylist();
}

Future<void> updatePlaylist(PlaylistModel data) async {
  final videoDB = await Hive.openBox<PlaylistModel>('video_db');
  await videoDB.put(data.id, data);
  getAllPlaylist();
}

Future<void> addToPlaylist(String videoPath, int playlistId) async {
  getAllPlaylist();

  PlaylistModel currentPlaylistData = PlaylistModel(
      id: playlistFolderNotifier.value[playlistId].id,
      playlistName: playlistFolderNotifier.value[playlistId].playlistName,
      playlist: playlistFolderNotifier.value[playlistId].playlist);

  currentPlaylistData.playlist ??= [];
  currentPlaylistData.playlist!.add(videoPath);

  updatePlaylist(currentPlaylistData);
  getAllPlaylist();
}

Future<void> clearVideosInPlaylist(int playlistId) async {
  getAllPlaylist();
  PlaylistModel currentPlaylistData = PlaylistModel(
      id: playlistFolderNotifier.value[playlistId].id,
      playlistName: playlistFolderNotifier.value[playlistId].playlistName,
      playlist: []);
  updatePlaylist(currentPlaylistData);
  getAllPlaylist();
}

Future addDefaultsToDb() async {
  final videoDB = await Hive.openBox<PlaylistModel>('video_db');
  bool isBoxEmpty = videoDB.isEmpty;
  getAllPlaylist();
  if (isBoxEmpty) {
    final data = PlaylistModel(playlistName: "Favourites");
    addPlaylist(data);
    getAllPlaylist();
  }
}

Future<void> closePlaylistDb() async {
  await Hive.close();
}

Future<void> clearPlaylistDb() async {
  final videoDB = await Hive.openBox<PlaylistModel>('video_db');
  await videoDB.clear();
  addDefaultsToDb();
  getAllPlaylist();
}

Future<void> playlistDbLength() async {
  final videoDB = await Hive.openBox<PlaylistModel>('video_db');
  videoDB.length;
  videoDB.keys.length;
  print(
      "videoDB.length; is ${videoDB.length} , videoDB.keys.length; is ${videoDB.keys.length}");
}
