import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html_unescape/html_unescape.dart';

class CustomResponseWidget extends StatelessWidget {
  final String content;

  const CustomResponseWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // コンテンツをパースしてウィジェットリストを生成
    final children = _parseContent(context, content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  // コンテンツを解析してウィジェットリストを生成するメソッド
  List<Widget> _parseContent(BuildContext context, String content) {
    final unescape = HtmlUnescape();
    final children = <Widget>[];

    // HTMLエンティティをデコード
    final decodedContent = unescape.convert(content);
    // 正規表現でURLを検出
    final urlPattern = RegExp(
        r'(http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+)|'
        r'(sssp://img\.5ch\.net/ico/[^<>\s]+\.gif)'
    );
    final matches = urlPattern.allMatches(decodedContent);

    int lastMatchEnd = 0;

    for (final match in matches) {
      final urlString = match.group(0)!;
      // URLの前のテキストを追加
      if (match.start > lastMatchEnd) {
        children.add(Text(decodedContent.substring(lastMatchEnd, match.start)));
      }
      // URLを表示するウィジェットを追加
      children.add(_buildUrlWidget(context, urlString));
      lastMatchEnd = match.end;
    }
    // 最後のURLの後のテキストを追加
    if (lastMatchEnd < decodedContent.length) {
      children.add(Text(decodedContent.substring(lastMatchEnd)));
    }

    return children;
  }

  // URLに応じたウィジェットを生成するメソッド
  Widget _buildUrlWidget(BuildContext context, String urlString) {
    // "sssp://" URLを"https://"に置き換える
    final displayUrl = urlString.startsWith('sssp') ? urlString.replaceFirst('sssp', 'https') : urlString;
    // URLが画像の場合はImage.networkを使用して表示
    if (displayUrl.endsWith('.jpg') || displayUrl.endsWith('.png') || displayUrl.endsWith('.gif') ||
        displayUrl.endsWith('.jpeg') || displayUrl.endsWith('.bmp') || displayUrl.endsWith('.tif') || displayUrl.endsWith('.tiff')) {
      return Image.network(displayUrl);
    } else {
      // 画像以外のURLをタップ可能にしてブラウザで開く
      return InkWell(
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
      );
    }
  }
}
