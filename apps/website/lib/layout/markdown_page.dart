import 'dart:io';

import 'package:jaspr/jaspr.dart';
import 'package:markdown/markdown.dart';

import '../constants/theme.dart';
import 'footer.dart';
import 'header.dart';

class MarkdownPage extends StatelessComponent {
  const MarkdownPage(this.filename, {super.key});

  final String filename;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final file = File(filename);
    final content = file.readAsStringSync();
    final html = markdownToHtml(content);

    yield Header(showHome: true);
    yield main_(classes: 'markdown-content', [
      raw(html),
    ]);
    yield Footer();
  }

  @css
  static final List<StyleRule> styles = [
    css('.markdown-content', [
      css('&').box(
        minHeight: 50.vh,
        padding: EdgeInsets.only(top: 8.rem, left: contentPadding, right: contentPadding, bottom: 4.rem),
      ),
      css('h3').box(margin: EdgeInsets.only(top: 3.rem)),
    ]),
  ];
}
