import 'package:flutter/material.dart';
import 'package:vdo_player/db/db_functions.dart';
import 'package:vdo_player/db/db_model.dart';

// import 'package:vdo_player/components/create_playlist_dialogue.dart';

Future showCreatePlaylistDialog(context) async {
  TextEditingController controller = TextEditingController();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Create Playlist"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter Playlist Name"),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text("Create"),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final playlist = PlaylistModel(playlistName: controller.text);
                addPlaylist(playlist);
              }
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
