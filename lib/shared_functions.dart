import 'package:flutter/material.dart';

Border determineBorder(int index, int columnCount) {
  bool isFirstRow = index < columnCount;
  return Border(
    top: isFirstRow ? const BorderSide(color: Colors.grey) : BorderSide.none,
    right: (index % columnCount == columnCount - 1) ? BorderSide.none : const BorderSide(color: Colors.grey),
    bottom: const BorderSide(color: Colors.grey),
  );
}
