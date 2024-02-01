import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';
import 'horizontal_drag_mixin.dart'; // Import the mixin

class ThreadListPage extends StatefulWidget {
  final String url;

  const ThreadListPage({Key? key, required this.url}) : super(key: key);

  @override
  ThreadListPageState createState() => ThreadListPageState();
}

class ThreadListPageState extends State<ThreadListPage> with HorizontalDragMixin {
  late Future<String> _htmlContent;

  @override
  void initState() {
    super.initState();
    _htmlContent = _fetchHtmlContent();
  }

  Future<String> _fetchHtmlContent() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      String? charset = response.headers['content-type']?.split('charset=')[1];
      charset ??= 'UTF-8';
      final decodedBody = await CharsetConverter.decode(charset, response.bodyBytes);
      return decodedBody;
    } else {
      throw Exception('Failed to load HTML content');
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
      ),
    );
  }
}
