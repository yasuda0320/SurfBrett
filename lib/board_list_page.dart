import 'package:flutter/material.dart';

class BoardListPage extends StatelessWidget {
  final String categoryName;

  BoardListPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Center(
        child: Text('Board list for $categoryName will be displayed here.'),
      ),
    );
  }
}
