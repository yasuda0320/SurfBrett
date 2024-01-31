import 'package:flutter/material.dart';
import 'category.dart';

class BoardListPage extends StatelessWidget {
  final Category category;
  final double _minimumDragDistance = 100; // 最小のフリック距離を設定

  const BoardListPage({Key? key, required this.category}) : super(key: key);

  Border _determineBorder(int index) {
    bool isFirstRow = index < 2; // Assuming 2 columns
    return Border(
      top: isFirstRow ? const BorderSide(color: Colors.grey) : BorderSide.none,
      right: (index % 2 == 0) ? const BorderSide(color: Colors.grey) : BorderSide.none,
      bottom: const BorderSide(color: Colors.grey),
    );
  }

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
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2列で表示
            crossAxisSpacing: 0.0, // 横方向の間隔
            mainAxisSpacing: 0.0, // 縦方向の間隔（行間）を小さくする
            childAspectRatio: 6, // アイテムの縦横比を調整
          ),
          itemCount: category.boards.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: _determineBorder(index),
              ),
              alignment: Alignment.center,
              child: Text(category.boards[index].boardName),
            );
          },
        ),
      ),
    );
  }
}
