import 'dart:io';
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'horizontal_drag_mixin.dart';

import 'bbs_data_class.dart';
import 'common.dart';
import 'response_list_page.dart';
import 'shared_functions.dart';
import 'slide_right_route.dart';

class ThreadListPage extends StatefulWidget {
  final BbsBoard board;

  const ThreadListPage({super.key, required this.board});

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
    final response = await http.get(Uri.parse('${widget.board.url}${Common.subjectPath}'));
    if (response.statusCode != HttpStatus.ok) {
      if (kDebugMode) {
        print('スレッド一覧の取得に失敗しました');
      }
      return [];
    }

    try {
      String charset = getCharsetFromResponse(response);
      final decodedBody = await CharsetConverter.decode(charset, response.bodyBytes);
      final lines = decodedBody.split('\n').where((line) => line.isNotEmpty).toList();
      List<BbsThreadInfo> threadInfoList = lines.map((line) {
        final parts = line.split('<>');
        if (parts.length >= 2) { // 有効なデータを持つ行のみ処理
          final title = parts[1];
          final dat = parts[0];
          final threadKey = dat.split('.')[0];
          final datUrl = '${widget.board.url}dat/$dat';
          return BbsThreadInfo(title: title, threadKey: threadKey, datUrl: datUrl);
        } else {
          return null; // 不正なデータの場合はnullを返す
        }
      }).where((thread) => thread != null).cast<BbsThreadInfo>().toList(); // nullを除外してリストを作成
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
    var unescape = HtmlUnescape();
    var titleDecoded = unescape.convert(threadInfo.title);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SlideRightRoute(page: ResponseListPage(threadInfo: threadInfo)),
        );
      },
      child: Container(
        decoration: decoration,
        child: ListTile(
          title: Text(
            titleDecoded,
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
