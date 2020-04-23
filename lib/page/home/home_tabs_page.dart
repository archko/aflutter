import 'package:AFlutter/page/list/gank_list_page.dart';
import 'package:AFlutter/page/movie/movie_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/widget/tabs/tab_bar_widget.dart';

class HomeTabsPage extends StatelessWidget {
  List<Widget> tabViews = [
    GankListPage(),
    MovieListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Home',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        //primaryColor: Colors.white,
      ),
      home: TabBarPageWidget(tabViews: tabViews),
    );
  }
}
