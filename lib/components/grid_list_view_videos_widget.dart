import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vdo_player/common.dart';
import 'package:vdo_player/components/common_functions.dart';
import 'package:vdo_player/components/threedot_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GridListViewVideosWidget extends StatefulWidget {
  GridListViewVideosWidget(
      {required this.dataList,
      required this.thumbnailImage,
      this.onTapFunction,
      this.enableDeleteAtThreeDot,
      this.enableThreeDot,
      this.deleteFunction,
      super.key});
  List dataList;
  Function? onTapFunction;
  Image thumbnailImage;
  Function? deleteFunction;
  bool? enableThreeDot; //null is treated as false
  bool? enableDeleteAtThreeDot; //null is treated as false

  @override
  State<GridListViewVideosWidget> createState() =>
      _GridListViewVideosWidgetState();
}

class _GridListViewVideosWidgetState extends State<GridListViewVideosWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: gridViewStateNotifierGlobal,
        builder: (context, gridViewState, child) {
          return gridViewState == 1
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: GridView.builder(
                      itemCount: widget.dataList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (widget.onTapFunction != null) {
                              widget.onTapFunction!(index);
                            }
                            generateThumbnail(widget.dataList[index]);
                          },
                          child: Column(
                            children: [
                              Stack(children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child: SizedBox(
                                      child: widget.thumbnailImage,
                                    )),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .35,
                                  height:
                                      MediaQuery.of(context).size.width * .3,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: FutureBuilder(
                                        future: getVideoInfo(
                                            widget.dataList[index]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            double milliseconds = snapshot.data;
                                            twoDigit(int n) =>
                                                n.toString().padLeft(2, "0");
                                            String hours = (milliseconds /
                                                    (1000 * 60 * 60))
                                                .floor()
                                                .toString();
                                            String minutes = twoDigit(
                                                (milliseconds /
                                                        (1000 * 60) %
                                                        60)
                                                    .floor());
                                            String seconds = twoDigit(
                                                (milliseconds / 1000 % 60)
                                                    .floor());

                                            if (hours != "0") {
                                              return Text(
                                                "$hours:$minutes:$seconds",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    backgroundColor:
                                                        Colors.black),
                                              );
                                            } else {
                                              return Text(
                                                "$minutes:$seconds",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    backgroundColor:
                                                        Colors.black),
                                              );
                                            }
                                          } else {
                                            return Text("");
                                          }
                                        }),
                                  ),
                                )
                              ]),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .3,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 0, 0, 0),
                                        child: Text(
                                          truncateWithEllipsis(
                                              25,
                                              widget.dataList[index]
                                                  .split('/')
                                                  .last),
                                          style: const TextStyle(fontSize: 14),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    widget.enableThreeDot == null
                                        ? const Text("")
                                        : ThreeDot(
                                            videoPath: widget.dataList[index],
                                            enableDelete:
                                                widget.enableDeleteAtThreeDot,
                                            index: index,
                                            deleteFunction: (index) {
                                              if (widget.deleteFunction !=
                                                  null) {
                                                return widget
                                                    .deleteFunction!(index);
                                              }
                                            })
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                )
              : widget.dataList.isEmpty
                  ? Center(child: Text("No videos found"))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                if (widget.onTapFunction != null) {
                                  widget.onTapFunction!(index);
                                }
                              },
                              leading: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: widget.thumbnailImage,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .15,
                                    height:
                                        MediaQuery.of(context).size.width * .12,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: FutureBuilder(
                                          future: getVideoInfo(
                                              widget.dataList[index]),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              double milliseconds =
                                                  snapshot.data;
                                              twoDigit(int n) =>
                                                  n.toString().padLeft(2, "0");
                                              String hours = (milliseconds /
                                                      (1000 * 60 * 60))
                                                  .floor()
                                                  .toString();
                                              String minutes = twoDigit(
                                                  (milliseconds /
                                                          (1000 * 60) %
                                                          60)
                                                      .floor());
                                              String seconds = twoDigit(
                                                  (milliseconds / 1000 % 60)
                                                      .floor());

                                              if (hours != "0") {
                                                return Text(
                                                  "$hours:$minutes:$seconds",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      backgroundColor:
                                                          Colors.black),
                                                );
                                              } else {
                                                return Text(
                                                  "$minutes:$seconds",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      backgroundColor:
                                                          Colors.black),
                                                );
                                              }
                                            } else {
                                              return Text("");
                                            }
                                          }),
                                    ),
                                  )
                                ],
                              ),
                              title: Text(truncateWithEllipsis(
                                  25, widget.dataList[index].split('/').last)),
                              trailing: widget.enableThreeDot == null
                                  ? const Text("")
                                  : ThreeDot(
                                      videoPath: widget.dataList[index],
                                      enableDelete:
                                          widget.enableDeleteAtThreeDot,
                                      index: index,
                                      deleteFunction: (index) {
                                        if (widget.deleteFunction != null) {
                                          return widget.deleteFunction!(index);
                                        }
                                      }),
                            );
                          },
                          itemCount: widget.dataList.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(thickness: 1)),
                    );
        });
  }

  Future getVideoInfo(videoPath) async {
    final videoInfo = FlutterVideoInfo();

    var info = await videoInfo.getVideoInfo(videoPath);
    double milliseconds = info?.duration ?? 0;

    return milliseconds;
  }

  Future generateThumbnail(videoPath) async {
    // String? thumbnailString = await VideoThumbnail.thumbnailFile(
    //   video: videoPath,
    //   thumbnailPath: (await getTemporaryDirectory()).path,
    //   imageFormat: ImageFormat.JPEG,
    //   maxWidth: 128,
    //   quality: 25,
    // );
    // print(thumbnailString);
    // print("Hai");
  }
}
