import 'dart:io';
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'horizontal_drag_mixin.dart';
import 'common.dart';

class ThreadListPage extends StatefulWidget {
  final String url;

  const ThreadListPage({Key? key, required this.url}) : super(key: key);

  @override
  ThreadListPageState createState() => ThreadListPageState();
}

class ThreadListPageState extends State<ThreadListPage> with HorizontalDragMixin {
  late Future<String> _htmlContent;

  @override
  void initState() {
    super.initState();
    _htmlContent = _fetchHtmlContent();
  }

  Future<String> _fetchHtmlContent() async {
    final response = await http.get(Uri.parse('${widget.url}${Common.subbackPath}'));
    if (response.statusCode != HttpStatus.ok) {
      return 'HTMLの取得に失敗しました';
    }

    String charset = response.headers['content-type']?.split('charset=')[1] ?? Common.defaultCharset;
    charset = (charset == Common.shiftJisCharset) ? Common.windowsCharset : charset;

    try {
      final decodedBody = await CharsetConverter.decode(charset, response.bodyBytes);
      return decodedBody;
    } catch (e) {
      return 'デコード中にエラーが発生しました。詳細: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: handleHorizontalDragStart,
      onHorizontalDragUpdate: handleHorizontalDragUpdate,
      onHorizontalDragEnd: (details) => handleHorizontalDragEnd(details, context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thread List'),
        ),
        body: FutureBuilder<String>(
          future: _htmlContent,
          builder: _buildHtmlContent,
        ),
      ),
    );
  }

  Widget _buildHtmlContent(BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return snapshot.hasError
          ? Text('エラーが発生しました。詳細: ${snapshot.error}')
          : _buildHtmlScrollView(snapshot.data ?? 'データがありません。');
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget _buildHtmlScrollView(String data) {
    return SingleChildScrollView(child: Text(data));
  }
}
