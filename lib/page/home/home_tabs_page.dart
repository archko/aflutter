import 'package:AFlutter/page/list/gank_list_page.dart';
import 'package:AFlutter/page/movie/movie_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/widget/tabs/tab_bar_widget.dart';
import 'package:flutter_base/widget/tabs/tabs_widget.dart';

class HomeTabsPage extends StatelessWidget {
  List<Widget> tabViews = [
    GankListPage(),
    MovieListPage(),
  ];
  List<TabItem> tabItems = <TabItem>[
    TabItem(icon: Icons.grade, text: 'GankGirl'),
    TabItem(icon: Icons.playlist_add, text: 'Movie'),
  ];
  ShapeDecoration _decoration = ShapeDecoration(
    shape: StadiumBorder(
          side: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ) +
        const StadiumBorder(
          side: BorderSide(
            color: Colors.transparent,
            width: 4.0,
          ),
        ),
  );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Home',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        //primaryColor: Colors.white,
      ),
      home: TabsWidget(
        type: TabsWidget.TOP_TAB,
        tabStyle: TabsStyle.textOnly,
        tabViews: tabViews,
        tabItems: tabItems,
        isScrollable: false,
        customIndicator: true,
        decoration: _decoration,
        title: Text("干货"),
      ),
    );
  }
}
