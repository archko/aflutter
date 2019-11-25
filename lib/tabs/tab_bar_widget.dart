import 'package:AFlutter/list/movie_list_page.dart';
import 'package:AFlutter/list/gank_json_list_page.dart';
import 'package:AFlutter/list/test_list_page.dart';
import 'package:AFlutter/state/test_provider_page.dart';
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

  _renderTab() {
    List<Widget> list = new List();
    for (int i = 0; i < tabs.length; i++) {
      list.add(new FlatButton(
          onPressed: () {
            pageControl.jumpTo(MediaQuery.of(context).size.width * i);
          },
          child: new Text(
            tabs[i],
            maxLines: 1,
          )));
    }
    return list;
  }

  _renderPage() {
    return [
      new MovieListPage(),
      new TestProviderPage(),
      new GankJsonListPage(),
    ];
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
