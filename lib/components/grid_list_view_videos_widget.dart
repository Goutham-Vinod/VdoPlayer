import 'package:flutter/material.dart';
import 'package:vdo_player/common.dart';
import 'package:vdo_player/components/common_functions.dart';
import 'package:vdo_player/components/threedot_widget.dart';

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
                          },
                          child: Column(
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: SizedBox(
                                    child: widget.thumbnailImage,
                                  )),
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
                              leading: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: widget.thumbnailImage,
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
}
