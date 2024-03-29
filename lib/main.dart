import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'board_list_page.dart';
import 'bbs_data_class.dart';
import 'common.dart';
import 'shared_functions.dart';
import 'slide_right_route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const locale = Locale("ja", "JP");
    return MaterialApp(
      title: 'SurfBrett',
      theme: ThemeData(
        fontFamily: 'NotoSansJP', // ここに日本語フォントファミリーを指定
      ),
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        locale,
      ],
      home: const JsonFetchPage(),
    );
  }
}

class JsonFetchPage extends StatefulWidget {
  const JsonFetchPage({super.key});

  @override
  JsonFetchPageState createState() => JsonFetchPageState();
}

class JsonFetchPageState extends State<JsonFetchPage> {
  List<BbsCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse(Common.bbsmenuUrl));
      if (response.statusCode == HttpStatus.ok) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> menuList = jsonData['menu_list'];

        setState(() {
          _categories = menuList.map<BbsCategory>((item) => BbsCategory.fromJson(item)).toList();
        });
      } else {
        // エラーステータスコードが返された場合の処理
        if (kDebugMode) {
          print('Error fetching data: ${response.statusCode}');
        }
        setState(() {
          _categories = [];
        });
      }
    } catch (e) {
      // ネットワークエラーやJSONのデコードエラーの捕捉
      if (kDebugMode) {
        print('Exception caught fetching data: $e');
      }
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
        itemBuilder: _buildCategoryItem,
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        SlideRightRoute(page: BoardListPage(category: _categories[index])),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: determineBorder(index, Common.categoryListColumn),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0), // 左右にパディングを設定
        alignment: Alignment.centerLeft, // テキストを左寄せにする
        child: Text(
          _categories[index].categoryName,
          overflow: TextOverflow.ellipsis, // テキストがオーバーフローしたら省略記号を表示
          style: const TextStyle(
            fontSize: 16, // Increase the font size
          ),
        ),
      ),
    );
  }
}
