import 'dart:io';
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'bbs_data_class.dart';
import 'custom_response_widget.dart';
import 'horizontal_drag_mixin.dart';
import 'shared_functions.dart';

// レス表示ページのクラス
class ResponseListPage extends StatefulWidget {
  final BbsThreadInfo threadInfo;

  const ResponseListPage({super.key, required this.threadInfo});

  @override
  ResponseListPageState createState() => ResponseListPageState();
}

class ResponseListPageState
    extends State<ResponseListPage> with HorizontalDragMixin<ResponseListPage> {
  late Future<List<BbsResponse>> _responses; // レスポンスのリストを非同期に取得するFuture

  @override
  void initState() {
    super.initState();
    _responses = _fetchResponses();
  }

  Future<List<BbsResponse>> _fetchResponses() async {
    final response = await http.get(Uri.parse(widget.threadInfo.datUrl));
    if (response.statusCode != HttpStatus.ok) {
      if (kDebugMode) {
        print('datの取得に失敗しました');
      }
      return [];
    }

    try {
      String charset = getCharsetFromResponse(response);
      final decodedBody = await CharsetConverter.decode(charset, response.bodyBytes);
      final links = decodedBody.split('\n');
      List<BbsResponse> responseList = links.where((link) => link.isNotEmpty).map((link) {
        final parts = link.split('<>'); // `<>`を区切り文字として分割
        if (parts.length >= 5) { // 期待される5つのパートが存在するかチェック
          // コンテンツ部分の`<br>`を`\n`に置き換え
          String content = parts[3].replaceAll('<br>', '\n');
          return BbsResponse(
            name: parts[0],
            email: parts[1],
            dateAndId: parts[2],
            content: content, // 置き換えられたコンテンツを使用
            threadTitle: parts.length > 4 ? parts[4] : '', // スレッドタイトルは省略可能とする
          );
        } else {
          // パートが不足している場合はnullを返し、後でフィルタリング
          return null;
        }
      }).where((response) => response != null).cast<BbsResponse>().toList();
      return responseList;
    } catch (e) {
      if (kDebugMode) {
        print('デコード中にエラーが発生しました。詳細: $e');
      }
      return [];
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
          title: Text(widget.threadInfo.title),
        ),
        body: FutureBuilder<List<BbsResponse>>(
          future: _responses,
          builder: _buildContent,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AsyncSnapshot<List<BbsResponse>> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) => _buildListItem(context, index, snapshot.data!),
        );
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
    }
    return const CircularProgressIndicator();
  }

  Widget _buildListItem(BuildContext context, int index, List<BbsResponse> data) {
    final response = data[index];
    String baseUrl = removeFileNameFromUrlString(widget.threadInfo.datUrl);
    baseUrl = removeFileNameFromUrlString(baseUrl);
    baseUrl = '${removeFileNameFromUrlString(baseUrl)}/';
    return Column(
      children: <Widget>[
        ListTile(
          title: CustomResponseWidget(content: response.content, baseUrl: baseUrl),
        ),
        const Divider(), // レス間にグリッド線を追加
      ],
    );
  }

  String removeFileNameFromUrlString(String url) {
    // 最後の '/' の位置を見つける
    int lastSlashIndex = url.lastIndexOf('/');
    if (lastSlashIndex == -1) {
      // '/' が見つからない場合は、元のURLをそのまま返す
      return url;
    } else {
      // 最後の '/' までの部分を取得して返す
      return url.substring(0, lastSlashIndex);
    }
  }
}
