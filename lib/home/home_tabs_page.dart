import 'package:AFlutter/page/movie_flutter_redux_page.dart';
import 'package:AFlutter/page/movie_list_page.dart';
import 'package:AFlutter/page/movie_provider_page.dart';
import 'package:AFlutter/page/theme_redux_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/widget/tabs/tab_bar_widget.dart';

class HomeTabsPage extends StatelessWidget {
  final List<Widget> widgets = [
    MovieProviderPage(),
    MovieFlutterReduxPage(),
    //ThemeReduxPage(),
    MovieListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new TabBarPageWidget(
        title: 'ProviderAndRedux',
        tabViews: widgets,
      ),
    );
  }
}
