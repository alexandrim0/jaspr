import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;
import 'package:website/constants/theme.dart';

import 'icon.dart';

class ThemeToggle extends StatefulComponent {
  const ThemeToggle({super.key});

  @override
  State createState() => ThemeToggleState();
}

class ThemeToggleState extends State<ThemeToggle> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) return;

    isDark = web.document.documentElement!.className == 'dark';
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    if (!kIsWeb) {
      yield Document.head(children: [
        // ignore: prefer_html_methods
        DomComponent(id: 'theme-script', tag: 'script', children: [
          raw('''
          let userTheme = window.localStorage.getItem('active-theme');
          if (userTheme != null) {
            document.documentElement.className = userTheme;
          } else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
            document.documentElement.className = 'dark';
          } else {
            document.documentElement.className = 'light';
          }
        ''')
        ]),
      ]);
    }

    if (kIsWeb) {
      yield Document.html(attributes: {'class': isDark ? 'dark' : 'light'});
    }

    yield button(
      classes: 'theme-toggle',
      onClick: () {
        setState(() {
          isDark = !isDark;
        });
        web.window.localStorage.setItem('active-theme', isDark ? 'dark' : 'light');
      },
      styles: !kIsWeb ? Styles.box(visibility: Visibility.hidden) : null,
      [Icon(isDark ? 'moon' : 'sun')],
    );
  }

  @css
  static final List<StyleRule> styles = [
    css('.theme-toggle', [
      css('&')
          .box(
              radius: BorderRadius.circular(8.px),
              border: Border.unset,
              outline: Outline.unset,
              padding: EdgeInsets.all(.7.rem))
          .flexbox(alignItems: AlignItems.center)
          .text(color: textBlack)
          .background(color: Colors.transparent),
      css('&:hover').background(color: hoverOverlayColor),
    ]),
  ];
}
