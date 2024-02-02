import 'package:flutter/material.dart';

class Common {
  static const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // 2列で表示
    crossAxisSpacing: 0.0, // 横方向の間隔
    mainAxisSpacing: 0.0, // 縦方向の間隔（行間）を小さくする
    childAspectRatio: 6, // アイテムの縦横比を調整
  );
  static const bbsmenuUrl = 'https://menu.5ch.net/bbsmenu.json';
  static const subbackPath = 'subback.html';
}
