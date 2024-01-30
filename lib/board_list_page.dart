import 'package:flutter/material.dart';
import 'category.dart';

class BoardListPage extends StatelessWidget {
  final Category category;
  final double _minimumDragDistance = 100; // 最小のフリック距離を設定

  const BoardListPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double startHorizontalDrag = 0.0;
    double endHorizontalDrag = 0.0;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        startHorizontalDrag = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        endHorizontalDrag = details.globalPosition.dx;
      },
      onHorizontalDragEnd: (details) {
        if (endHorizontalDrag - startHorizontalDrag > _minimumDragDistance) {
          // 左から右へのフリックを検出（最小フリック距離を超えているか確認）
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.categoryName),
        ),
        body: ListView.builder(
          itemCount: category.boards.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(category.boards[index].boardName),
            );
          },
        ),
      ),
    );
  }
}
