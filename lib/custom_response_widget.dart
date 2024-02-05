import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomResponseWidget extends StatelessWidget {
  final String content;

  const CustomResponseWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // 正規表現でURLを検出
    final urlPattern = RegExp(r'(http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+)');
    final matches = urlPattern.allMatches(content);

    List<Widget> children = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      final urlString = match.group(0)!;
      // URLの前のテキストを追加
      if (match.start > lastMatchEnd) {
        children.add(Text(content.substring(lastMatchEnd, match.start)));
      }
      // URLが画像の場合はImage.networkを、そうでない場合はリンクとして表示
      if (urlString.endsWith('.jpg') || urlString.endsWith('.png') || urlString.endsWith('.gif')) {
        children.add(Image.network(urlString));
      } else {
        // URLをタップ可能にしてブラウザで開く
        children.add(InkWell(
          child: Text(urlString, style: const TextStyle(color: Colors.blue)),
          onTap: () => launch(urlString),
        ));
      }
      lastMatchEnd = match.end;
    }
    // 最後のURLの後のテキストを追加
    if (lastMatchEnd < content.length) {
      children.add(Text(content.substring(lastMatchEnd)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
