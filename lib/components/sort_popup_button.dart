import 'package:flutter/material.dart';
import 'package:vdo_player/components/common_functions.dart';
import 'package:vdo_player/common.dart';
//import 'package:vdo_player/components/sort_popup.dart';

Widget sortPopupButton(BuildContext context) {
  return PopupMenuButton(
    icon: const Icon(
      Icons.sort,
      size: 20,
    ),
    itemBuilder: (context) {
      List<PopupMenuItem<String>> popupMenuItemList = [
        const PopupMenuItem(value: "A to B", child: Text("A to B")),
        const PopupMenuItem(value: "B to A", child: Text("B to A")),
      ];

      return popupMenuItemList;
    },
    onSelected: (String? value) {
      switch (value) {
        case "A to B":
          videosGlobalNotifier.value.sort((a, b) {
            return findFileName(a)
                .toString()
                .toLowerCase()
                .compareTo(findFileName(b).toString().toLowerCase());
          });
          videosGlobalNotifier.notifyListeners();
          break;
        case "B to A":
          videosGlobalNotifier.value.sort((a, b) {
            return findFileName(b)
                .toString()
                .toLowerCase()
                .compareTo(findFileName(a).toString().toLowerCase());
          });
          videosGlobalNotifier.notifyListeners();
          break;
        default:
      }
    },
  );
}
