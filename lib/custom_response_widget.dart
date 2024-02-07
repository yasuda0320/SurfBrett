import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html_unescape/html_unescape.dart';

class CustomResponseWidget extends StatelessWidget {
  final String content;
  final String baseUrl;

  const CustomResponseWidget({super.key, required this.content, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    final children = _parseContent(context, content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  List<Widget> _parseContent(BuildContext context, String content) {
    final unescape = HtmlUnescape();
    final children = <Widget>[];
    final urlPattern = RegExp(
        r'<a\s+(?:[^>]*?\s+)?href="([^"]*)"(?:[^>]*)>(.*?)<\/a>|'
        r'(http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+)|'
        r'(sssp://img\.5ch\.net/ico/[^<>\s]+\.gif)'
    );
    final matches = urlPattern.allMatches(content);

    int lastMatchEnd = 0;

    for (final match in matches) {
      final fullMatch = match.group(0)!;
      // URLの前のテキストを追加
      if (match.start > lastMatchEnd) {
        // タグの外側のテキストをデコードして追加
        children.add(Text(unescape.convert(content.substring(lastMatchEnd, match.start))));
      }

      if (fullMatch.startsWith('<a href="')) {
        final href = match.group(1)!;
        final linkText = match.group(2)!;
        // 相対パスを絶対パスに変換
        String absoluteUrl = href;
        if (href.startsWith('../test/read.cgi/')) {
          // Uri.parse(baseUrl)でベースURLをUriオブジェクトに変換し、resolveメソッドを使用して絶対パスを生成
          absoluteUrl = Uri.parse(baseUrl).resolve(href.substring(3)).toString();
        }
        children.add(InkWell(
          child: Text(unescape.convert(linkText), style: const TextStyle(color: Colors.blue)),
          onTap: () => _showPopup(context, absoluteUrl),
        ));
      } else { // 通常のURLの処理
        final displayUrl = fullMatch.startsWith('sssp') ? fullMatch.replaceFirst('sssp', 'https') : fullMatch;
        children.add(_buildUrlWidget(context, displayUrl));
      }

      lastMatchEnd = match.end;
    }

    // 最後のURLの後のテキスト（タグの外側）をデコードして追加
    if (lastMatchEnd < content.length) {
      children.add(Text(unescape.convert(content.substring(lastMatchEnd))));
    }

    return children;
  }

  void _showPopup(BuildContext context, String href) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(href),
          actions: <Widget>[
            TextButton(
              child: const Text('閉じる'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUrlWidget(BuildContext context, String urlString) {
    // URLが画像の場合はImage.networkを使用して表示
    if (urlString.endsWith('.jpg') || urlString.endsWith('.png') || urlString.endsWith('.gif') ||
        urlString.endsWith('.jpeg') || urlString.endsWith('.bmp') || urlString.endsWith('.tif') || urlString.endsWith('.tiff')) {
      return GestureDetector(
        onTap: () {
          // 画像をタップしたときにフルサイズで画像を表示するポップアップを表示
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  width: double.maxFinite,
                  child: Image.network(urlString, fit: BoxFit.contain),
                ),
              );
            },
          );
        },
        child: Container(
          // サムネイルを表示するためにサイズを小さく設定
          width: 100, // サムネイルの幅
          height: 100, // サムネイルの高さ
          child: Image.network(urlString, fit: BoxFit.cover),
        ),
      );
    } else {
      // 画像以外のURLをタップ可能にしてブラウザで開く
      return InkWell(
        child: Text(urlString, style: const TextStyle(color: Colors.blue)),
        onTap: () async {
          final url = Uri.parse(urlString);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            if (kDebugMode) {
              print('Could not launch $url');
            }
          }
        },
      );
    }
  }
}
