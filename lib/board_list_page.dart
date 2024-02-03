import 'package:flutter/material.dart';
import 'bbs_category.dart';
import 'shared_functions.dart';
import 'common.dart';
import 'slide_right_route.dart';
import 'thread_list_page.dart';
import 'horizontal_drag_mixin.dart'; // Import the mixin

class BoardListPage extends StatefulWidget {
  final BbsCategory category;

  const BoardListPage({Key? key, required this.category}) : super(key: key);

  @override
  BoardListPageState createState() => BoardListPageState();
}

class BoardListPageState extends State<BoardListPage> with HorizontalDragMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: handleHorizontalDragStart,
      onHorizontalDragUpdate: handleHorizontalDragUpdate,
      onHorizontalDragEnd: (details) => handleHorizontalDragEnd(details, context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category.categoryName),
        ),
        body: GridView.builder(
          gridDelegate: Common.gridDelegate,
          itemCount: widget.category.boards.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    SlideRightRoute(
                        page: ThreadListPage(url: widget.category.boards[index].url)
                    )
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: determineBorder(index, Common.boardListColumn),
                ),
                alignment: Alignment.center,
                child: Text(widget.category.boards[index].boardName),
              ),
            );
          },
        ),
      ),
    );
  }
}
