import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  String _data = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://menu.5ch.net/bbsmenu.json'));

    if (response.statusCode == 200) {
      setState(() {
        // 明示的にUTF-8でデコード
        _data = utf8.decode(response.bodyBytes);
      });
    } else {
      setState(() {
        _data = 'Failed to load data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Fetch Example'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(_data),
        ),
      ),
    );
  }
}
