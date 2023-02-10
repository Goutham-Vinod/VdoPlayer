// import 'package:vdo_player/components/common_functions.dart';
// import 'package:vdo_player/components/common_widgets.dart';
// import 'package:vdo_player/common.dart';

searchFromStringList(String query, stringList) {
  List suggestions = stringList.where((stringElement) {
    String findString = query.toLowerCase().trim();
    final mainString = stringElement.toString().toLowerCase();
    return mainString.contains(findString);
  }).toList();

  return suggestions;
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

findUniqueFiles(videos) {
  List uniqueFiles = videos.toSet().toList();
  return uniqueFiles;
}

findFileName(filePath) {
  String fileName = filePath.split('/').last;
  return fileName;
}

findUniqueFolders(videos) {
  List uniqueFolders = [];
  List folders = findFolders(videos);
  uniqueFolders = folders.toSet().toList();
  return uniqueFolders;
}

findFolders(videos) {
  List folders = [];
  for (int i = 0; i < videos.length; i++) {
    folders.add(findFolderPath(videos[i]));
  }
  return folders;
}

findFolderPath(video) {
  String folderPath = "";
  List folders = video.split('/');
  String folderName = video.split('/')[folders.length - 2];

  for (int i = 0; i < folders.length; i++) {
    String folder = folders[i];

    if (folder != folderName) {
      folderPath += "$folder/";
    } else {
      break;
    }
  }
  folderPath += folderName;
  return folderPath;
}

findFolderName(folderPath) {
  String folderName = folderPath.split('/').last;
  return folderName;
}
