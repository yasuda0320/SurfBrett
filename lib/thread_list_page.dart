import 'dart:io';
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'horizontal_drag_mixin.dart';
import 'common.dart';
import 'bbs_data_class.dart';
import 'response_list_page.dart';

class ThreadListPage extends StatefulWidget {
  final BbsBoard board;

  const ThreadListPage({Key? key, required this.board}) : super(key: key);

  @override
  ThreadListPageState createState() => ThreadListPageState();
}

class ThreadListPageState
    extends State<ThreadListPage> with HorizontalDragMixin {
  late Future<List<BbsThreadInfo>> _threadInfoList;

  @override
  void initState() {
    super.initState();
    _threadInfoList = _fetchThreadTitles();
  }

  Future<List<BbsThreadInfo>> _fetchThreadTitles() async {
    final response = await http.get(Uri.parse('${widget.board.url}${Common.subbackPath}'));
    if (response.statusCode != HttpStatus.ok) {
      if (kDebugMode) {
        print('HTMLの取得に失敗しました');
      }
      return [];
    }

    String charset = response.headers['content-type']?.split('charset=')[1] ?? Common.defaultCharset;
    charset = (charset == Common.shiftJisCharset) ? Common.windowsCharset : charset;

    try {
      final decodedBody = await CharsetConverter.decode(charset, response.bodyBytes);
      var document = html_parser.parse(decodedBody);
      List<dom.Element> links = document.querySelectorAll(Common.threadListSelector);
      List<BbsThreadInfo> threadInfoList = links.map((link) {
        final title = link.text;
        final url = link.attributes['href'] ?? ''; // hrefがない場合は空文字列を使用
        return BbsThreadInfo(title: title, url: url);
      }).toList();
      return threadInfoList; //.reversed.toList();
    } catch (e) {
      if (kDebugMode) {
        print('デコード中にエラーが発生しました。詳細: $e');
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.board.boardName),
      ),
      body: GestureDetector(
        onHorizontalDragStart: handleHorizontalDragStart,
        onHorizontalDragUpdate: handleHorizontalDragUpdate,
        onHorizontalDragEnd: (details) => handleHorizontalDragEnd(details, context),
        child: FutureBuilder<List<BbsThreadInfo>>(
          future: _threadInfoList,
          builder: _buildContent,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AsyncSnapshot<List<BbsThreadInfo>> snapshot) {
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) => _buildListItem(context, index, snapshot.data!),
      );
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    return const CircularProgressIndicator();
  }

  Widget _buildListItem(BuildContext context, int index, List<BbsThreadInfo> data) {
    final threadInfo = data[index];
    BoxDecoration decoration = _buildItemDecoration(index);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResponseListPage(threadInfo: threadInfo)),
        );
      },
      child: Container(
        decoration: decoration,
        child: ListTile(
          title: Text(
            threadInfo.title,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildItemDecoration(int index) {
    if (index == 0) {
      // 最初のアイテムのため上側と下側にグリッド線を追加
      return const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
          bottom: BorderSide(color: Colors.grey),
        ),
      );
    } else {
      // 下側にのみグリッド線を追加
      return const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      );
    }
  }
}
