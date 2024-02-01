import 'package:flutter/material.dart';
import 'category.dart';
import 'shared_functions.dart';
import 'common.dart';
import 'slide_right_route.dart';
import 'thread_list_page.dart';

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
        body: GridView.builder(
          gridDelegate: CommonConfig.gridDelegate,
          itemCount: category.boards.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    SlideRightRoute(
                        page: ThreadListPage(url: category.boards[index].url)
                    )
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: determineBorder(index, 2), // Assuming 2 columns here
                ),
                alignment: Alignment.center,
                child: Text(category.boards[index].boardName),
              ),
            );
          },
        ),
      ),
    );
  }
}
