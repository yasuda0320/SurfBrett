import 'package:flutter/material.dart';
import 'bbs_data_class.dart';
import 'shared_functions.dart';
import 'common.dart';
import 'slide_right_route.dart';
import 'thread_list_page.dart';
import 'horizontal_drag_mixin.dart';

class BoardListPage extends StatefulWidget {
  final BbsCategory category;

  const BoardListPage({super.key, required this.category});

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
      // alignment: Alignment.center, // この行は削除またはコメントアウトします
      child: Align(
        alignment: Alignment.centerLeft, // ここでテキストを左寄せに設定
        child: Padding(
          padding: const EdgeInsets.all(15.0), // 左寄せテキストのためのパディングを追加
          child: Text(
            widget.category.boards[index].boardName,
            textAlign: TextAlign.left, // テキスト自体も左寄せにする
            overflow: TextOverflow.ellipsis, // テキストがオーバーフローしたら省略記号を表示
            style: const TextStyle(
              fontSize: 16, // Increase the font size
            ),
          ),
        ),
      ),
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
