import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'board_list_page.dart';
import 'slide_right_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: JsonFetchPage(),
    );
  }
}

class JsonFetchPage extends StatefulWidget {
  @override
  _JsonFetchPageState createState() => _JsonFetchPageState();
}

class _JsonFetchPageState extends State<JsonFetchPage> {
  List<String> _categoryNames = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://menu.5ch.net/bbsmenu.json'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> menuList = jsonData['menu_list'];

      setState(() {
        _categoryNames = menuList.map((item) => item['category_name'].toString()).toList();
      });
    } else {
      setState(() {
        _categoryNames = ['Failed to load data'];
      });
    }
  }

  Border _determineBorder(int index) {
    bool isFirstRow = index < 2; // 2列なので、インデックスが0または1の場合は最初の行
    return Border(
      top: isFirstRow ? BorderSide(color: Colors.grey) : BorderSide.none,
      right: (index % 2 == 0) ? BorderSide(color: Colors.grey) : BorderSide.none,
      bottom: BorderSide(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Names with Grid Lines'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2列で表示
          crossAxisSpacing: 0.0, // 横方向の間隔
          mainAxisSpacing: 0.0, // 縦方向の間隔（行間）を小さくする
          childAspectRatio: 6, // アイテムの縦横比を調整
        ),
        itemCount: _categoryNames.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, SlideRightRoute(page: BoardListPage(categoryName: _categoryNames[index])));
            },
            child: Container(
              decoration: BoxDecoration(
                border: _determineBorder(index),
              ),
              alignment: Alignment.center,
              child: Text(_categoryNames[index]),
            ),
          );
        },
      ),
    );
  }
}
