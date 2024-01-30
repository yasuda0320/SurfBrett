import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'board_list_page.dart';
import 'slide_right_route.dart';
import 'category.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: JsonFetchPage(),
    );
  }
}

class JsonFetchPage extends StatefulWidget {
  const JsonFetchPage({super.key});

  @override
  JsonFetchPageState createState() => JsonFetchPageState();
}

class JsonFetchPageState extends State<JsonFetchPage> {
  List<Category> _categories = [];

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
        _categories = menuList.map<Category>((item) => Category.fromJson(item)).toList();
      });
    } else {
      setState(() {
        _categories = [];
      });
    }
  }

  Border _determineBorder(int index) {
    bool isFirstRow = index < 2; // 2列なので、インデックスが0または1の場合は最初の行
    return Border(
      top: isFirstRow ? const BorderSide(color: Colors.grey) : BorderSide.none,
      right: (index % 2 == 0) ? const BorderSide(color: Colors.grey) : BorderSide.none,
      bottom: const BorderSide(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5ch.net'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2列で表示
          crossAxisSpacing: 0.0, // 横方向の間隔
          mainAxisSpacing: 0.0, // 縦方向の間隔（行間）を小さくする
          childAspectRatio: 6, // アイテムの縦横比を調整
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  SlideRightRoute(
                      page: BoardListPage(category: _categories[index])
                  )
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: _determineBorder(index),
              ),
              alignment: Alignment.center,
              child: Text(_categories[index].categoryName),
            ),
          );
        },
      ),
    );
  }
}
