import 'package:flutter/material.dart';

class Common {
  static const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // 2列で表示
    crossAxisSpacing: 0.0, // 横方向の間隔
    mainAxisSpacing: 0.0, // 縦方向の間隔（行間）を小さくする
    childAspectRatio: 4, // アイテムの縦横比を調整
  );
  static const bbsTitle = '5ちゃんねる';
  static const categoryListColumn = 2;
  static const boardListColumn = 2;
  static const bbsmenuUrl = 'https://menu.5ch.net/bbsmenu.json';
  static const subjectPath = 'subject.txt';
  static const defaultCharset = 'UTF-8';
  static const shiftJisCharset = 'Shift_JIS';
  static const windowsCharset = 'windows-31j';
  static const threadListSelector = 'small#trad > a';
}
