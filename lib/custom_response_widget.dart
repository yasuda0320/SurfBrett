import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomResponseWidget extends StatelessWidget {
  final String content;

  const CustomResponseWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // 正規表現でURLを検出
    final urlPattern = RegExp(
        r'(http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+)|'
        r'(sssp://img\.5ch\.net/ico/[^<>\s]+\.gif)'
    );
    final matches = urlPattern.allMatches(content);

    List<Widget> children = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      final urlString = match.group(0)!;
      // URLの前のテキストを追加
      if (match.start > lastMatchEnd) {
        children.add(Text(content.substring(lastMatchEnd, match.start)));
      }
      // "sssp://" URLを"https://"に置き換える
      final displayUrl = urlString.startsWith('sssp') ? urlString.replaceFirst('sssp', 'https') : urlString;
      // URLが画像の場合はImage.networkを使用して表示
      if (displayUrl.endsWith('.jpg') || displayUrl.endsWith('.png') || displayUrl.endsWith('.gif') ||
          displayUrl.endsWith('.jpeg') || displayUrl.endsWith('.bmp') || displayUrl.endsWith('.tif') || displayUrl.endsWith('.tiff')) {
        children.add(Image.network(displayUrl));
      } else {
        // 画像以外のURLをタップ可能にしてブラウザで開く
        children.add(InkWell(
          child: Text(displayUrl, style: const TextStyle(color: Colors.blue)),
          onTap: () async {
            final url = Uri.parse(displayUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              // URLを開けなかった場合の処理
              if (kDebugMode) {
                print('URLを開けません: $url');
              }
            }
          },
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
