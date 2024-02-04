import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common.dart';

Border determineBorder(int index, int columnCount) {
  bool isFirstRow = index < columnCount;
  return Border(
    top: isFirstRow ? const BorderSide(color: Colors.grey) : BorderSide.none,
    right: (index % columnCount == columnCount - 1) ? BorderSide.none : const BorderSide(color: Colors.grey),
    bottom: const BorderSide(color: Colors.grey),
  );
}

// http responseからcharsetを取得する
String getCharsetFromResponse(http.Response response) {
  String contentType = response.headers['content-type'] ?? '';
  String charset = Common.windowsCharset;
  if (contentType.contains('charset=')) {
    charset = contentType.split('charset=')[1].split(';')[0];
  }
  charset = (charset == Common.shiftJisCharset) ? Common.windowsCharset : charset;
  return charset;
}