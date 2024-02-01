import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';

class ThreadListPage extends StatefulWidget {
  final String url;

  const ThreadListPage({Key? key, required this.url}) : super(key: key);

  @override
  _ThreadListPageState createState() => _ThreadListPageState();
}

class _ThreadListPageState extends State<ThreadListPage> {
  late Future<String> _htmlContent;

  @override
  void initState() {
    super.initState();
    _htmlContent = _fetchHtmlContent();
  }

  Future<String> _fetchHtmlContent() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      // Content-Typeヘッダーからcharsetを抽出
      String? charset = response.headers['content-type']?.split('charset=')[1];
      charset ??= 'UTF-8'; // デフォルトをUTF-8とする

      // charset_converterを使用して適切なエンコーディングでデコード
      final decodedBody = await CharsetConverter.decode(charset, response.bodyBytes);
      return decodedBody;
    } else {
      throw Exception('Failed to load HTML content');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thread List'),
      ),
      body: FutureBuilder<String>(
        future: _htmlContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return SingleChildScrollView(
              child: Text(snapshot.data ?? 'No data'),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
