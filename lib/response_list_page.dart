import 'package:flutter/material.dart';
import 'bbs_data_class.dart';
import 'horizontal_drag_mixin.dart';

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
    _responses = _fetchResponses(); // レスをフェッチする関数のダミー
  }

  Future<List<BbsResponse>> _fetchResponses() async {
    // ここでURLからレスをフェッチするロジックを実装
    // 現時点ではダミーのリストを返す
    return []; // TODO: 実際のフェッチ処理に置き換える
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
    return ListTile(
      title: Text(response.content),
    );
  }
}
