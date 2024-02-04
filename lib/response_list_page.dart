import 'dart:io';
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'bbs_data_class.dart';
import 'horizontal_drag_mixin.dart';
import 'shared_functions.dart';

// レス表示ページのクラス
class ResponseListPage extends StatefulWidget {
  final BbsThreadInfo threadInfo;

  const ResponseListPage({Key? key, required this.threadInfo}) : super(key: key);

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
      List<BbsResponse> responseList = links.map((link) {
        return BbsResponse(content: link);
      }).toList();
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
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(response.content),
        ),
        const Divider(), // レス間にグリッド線を追加
      ],
    );
  }
}
