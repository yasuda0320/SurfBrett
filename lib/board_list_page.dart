import 'package:flutter/material.dart';
import 'bbs_data_class.dart';
import 'shared_functions.dart';
import 'common.dart';
import 'slide_right_route.dart';
import 'thread_list_page.dart';
import 'horizontal_drag_mixin.dart';

class BoardListPage extends StatefulWidget {
  final BbsCategory category;

  const BoardListPage({Key? key, required this.category}) : super(key: key);

  @override
  BoardListPageState createState() => BoardListPageState();
}

class BoardListPageState extends State<BoardListPage> with HorizontalDragMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.categoryName),
      ),
      body: GestureDetector(
        onHorizontalDragStart: handleHorizontalDragStart,
        onHorizontalDragUpdate: handleHorizontalDragUpdate,
        onHorizontalDragEnd: (details) => handleHorizontalDragEnd(details, context),
        child: GridView.builder(
          gridDelegate: Common.gridDelegate,
          itemCount: widget.category.boards.length,
          itemBuilder: _buildBoardItem,
        ),
      ),
    );
  }

  Widget _buildBoardItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _navigateToThreadListPage(context, index),
      child: _buildBoardContainer(index),
    );
  }

  Widget _buildBoardContainer(int index) {
    return Container(
      decoration: BoxDecoration(
        border: determineBorder(index, Common.boardListColumn),
      ),
      alignment: Alignment.center,
      child: Text(widget.category.boards[index].boardName),
    );
  }

  void _navigateToThreadListPage(BuildContext context, int index) {
    Navigator.push(
      context,
      SlideRightRoute(
        page: ThreadListPage(board: widget.category.boards[index]),
      ),
    );
  }
}
