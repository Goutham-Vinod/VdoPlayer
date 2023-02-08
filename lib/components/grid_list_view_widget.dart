import 'package:flutter/material.dart';
import 'package:vdo_player/common.dart';
import 'package:vdo_player/components/common_functions.dart';
import 'package:vdo_player/components/threedot_widget.dart';

class GridListViewWidget extends StatefulWidget {
  GridListViewWidget(
      {required this.dataList,
      required this.thumbnailImage,
      this.onTapFunction,
      this.crossAxisCount,
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
  int? crossAxisCount;
  //if null then crossAxisCount will be 2 (only 2 or 3 can be used)

  @override
  State<GridListViewWidget> createState() => _GridListViewWidgetState();
}

class _GridListViewWidgetState extends State<GridListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: gridViewStateNotifierGlobal,
        builder: (context, gridViewState, child) {
          return gridViewState == 1
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                      itemCount: widget.dataList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.crossAxisCount == null
                              ? 2
                              : widget.crossAxisCount!,
                          crossAxisSpacing: 1),
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
                                    height: widget.crossAxisCount == null
                                        ? 100
                                        : 50,
                                    child: widget.thumbnailImage,
                                  )),
                              widget.crossAxisCount == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 135,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                30, 0, 0, 0),
                                            child: Text(
                                              truncateWithEllipsis(
                                                  25,
                                                  widget.dataList[index]
                                                      .split('/')
                                                      .last),
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        widget.enableThreeDot == null
                                            ? const Text("")
                                            : ThreeDot(
                                                videoPath:
                                                    widget.dataList[index],
                                                enableDelete: widget
                                                    .enableDeleteAtThreeDot,
                                                index: index,
                                                deleteFunction: (index) {
                                                  if (widget.deleteFunction !=
                                                      null) {
                                                    return widget
                                                        .deleteFunction!(index);
                                                  }
                                                })
                                      ],
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Text(
                                        truncateWithEllipsis(
                                            25,
                                            widget.dataList[index]
                                                .split('/')
                                                .last),
                                        style: const TextStyle(fontSize: 13),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                            ],
                          ),
                        );
                      }),
                )
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
                                  enableDelete: widget.enableDeleteAtThreeDot,
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
