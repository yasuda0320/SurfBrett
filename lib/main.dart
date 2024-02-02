import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'board_list_page.dart';
import 'slide_right_route.dart';
import 'category.dart';
import 'shared_functions.dart';
import 'common.dart';
import 'dart:io';

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
    final response = await http.get(Uri.parse(Common.bbsmenuUrl));

    if (response.statusCode == HttpStatus.ok) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Common.bbsTitle),
      ),
      body: GridView.builder(
        gridDelegate: Common.gridDelegate,
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
                border: determineBorder(index, Common.categoryListColumn),
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
