import 'package:flutter/material.dart';

class CommonConfig {
  static const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // 2列で表示
    crossAxisSpacing: 0.0, // 横方向の間隔
    mainAxisSpacing: 0.0, // 縦方向の間隔（行間）を小さくする
    childAspectRatio: 6, // アイテムの縦横比を調整
  );
}
