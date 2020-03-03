import 'package:AFlutter/page/movie_flutter_redux_page.dart';
import 'package:AFlutter/page/movie_list_page.dart';
import 'package:AFlutter/page/movie_provider_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/widget/tabs/tab_bar_widget.dart';

class HomeTabsPage extends StatelessWidget {
  List<Widget> widgets = [
    MovieProviderPage(),
    MovieFlutterReduxPage(),
    MovieListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        //primaryColor: Colors.white,
      ),
      home: new TabBarPageWidget(
        title: 'ProviderAndRedux',
        tabViews: widgets,
      ),
    );
  }
}
