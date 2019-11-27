import 'package:AFlutter/list/gank_list_page.dart';
import 'package:AFlutter/list/movie_list_page.dart';
import 'package:AFlutter/list/test_list_page.dart';
import 'package:flutter/material.dart';

import 'gsy_tab_bar_widget.dart';

class TabBarPageWidget extends StatefulWidget {
  final String title;

  const TabBarPageWidget({Key key, this.title}) : super(key: key);

  @override
  _TabBarPageWidgetState createState() => _TabBarPageWidgetState();
}

class _TabBarPageWidgetState extends State<TabBarPageWidget> {
  final PageController pageControl = new PageController();

  final List<String> tabs = ["first", "second", "third", "fouth"];
  final List<Widget> tabViews = [
    new TestListPage(),
    new GankListPage(
      type: '福利',
    ),
    new GankListPage(
      type: 'Android',
    ),
    new MovieListPage(),
  ];

  _renderTab() {
    List<Widget> list = new List();
    for (int i = 0; i < tabViews.length; i++) {
      list.add(new FlatButton(
          onPressed: () {
            pageControl.jumpTo(MediaQuery.of(context).size.width * i);
          },
          child: new Text(
            tabViews[i].toStringShort(),
            maxLines: 1,
          )));
    }
    return list;
  }

  _renderPage() {
    return tabViews;
    //return [
    //  new GankListPage(),
    //  new GankListPage(
    //    type: 'Android',
    //  ),
    //  new MovieListPage(),
    //  new GankJsonListPage(),
    //  new TestProviderPage(),
    //];
  }

  @override
  Widget build(BuildContext context) {
    return new GSYTabBarWidget(
        type: GSYTabBarWidget.TOP_TAB,
        tabItems: _renderTab(),
        tabViews: _renderPage(),
        pageControl: pageControl,
        backgroundColor: Colors.lightBlue,
        indicatorColor: Colors.white,
        title: new Text(widget.title == null ? "" : widget.title));
  }
}
