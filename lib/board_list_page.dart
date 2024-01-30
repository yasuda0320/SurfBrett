import 'package:flutter/material.dart';

class BoardListPage extends StatelessWidget {
  final String categoryName;
  final double _minimumDragDistance = 100; // 最小のフリック距離を設定

  const BoardListPage({Key? key, required this.categoryName}) : super(key: key);

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
          title: Text(categoryName),
        ),
        body: Center(
          child: Text('Board list for $categoryName will be displayed here.'),
        ),
      ),
    );
  }
}
