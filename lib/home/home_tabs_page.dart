import 'package:AFlutter/model/list_view_model.dart';
import 'package:AFlutter/page/movie_flutter_redux_page.dart';
import 'package:AFlutter/page/movie_list_page.dart';
import 'package:AFlutter/page/movie_provider_page.dart';
import 'package:AFlutter/page/theme_redux_page.dart';
import 'package:AFlutter/redux/app_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/widget/tabs/tab_bar_widget.dart';
import 'package:flutter_base/widget/tabs/tabs_widget.dart';
import 'package:flutter_redux/flutter_redux.dart';

const List<TabItem> tabItems = <TabItem>[
  TabItem(icon: Icons.grade, text: 'Redux'),
  TabItem(icon: Icons.grade, text: 'Theme'),
  TabItem(icon: Icons.playlist_add, text: 'Provider'),
  TabItem(icon: Icons.check_circle, text: 'SetState'),
];

class HomeTabsPage extends StatefulWidget {
  final List<Widget> widgets = [
    MovieFlutterReduxPage(),
    ThemeReduxPage(),
    MovieProviderPage(),
    MovieListPage(),
  ];

  @override
  HomeTabsPageState createState() => HomeTabsPageState();
}

class HomeTabsPageState extends State<HomeTabsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabItems.length);
    this._tabController.addListener(() {
      /// 这里需要去重,否则会调用两次._tabController.animation.value才是最后的位置
      if (_tabController.animation.value == _tabController.index) {
        print(
            "index:${_tabController.index},preIndex:${_tabController.previousIndex},length:${_tabController.length}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TabsWidget(
      type: TabsWidget.TOP_TAB,
      tabController: _tabController,
      tabStyle: TabsStyle.textOnly,
      tabViews: widget.widgets,
      tabItems: tabItems,
      title: Text("AppBar title"),
    );
  }

  ///@override
  ///Widget build(BuildContext context) {
  ///  return new MaterialApp(
  ///    home: new TabBarPageWidget(
  ///      title: 'ProviderAndRedux',
  ///      tabViews: widgets,
  ///    ),
  ///  );
  ///}
}
