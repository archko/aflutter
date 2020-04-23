import 'package:AFlutter/model/provider/home_provider.dart';
import 'package:AFlutter/page/list/gank_list_page.dart';
import 'package:AFlutter/page/movie/movie_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/provider_widget.dart';
import 'package:flutter_base/widget/tabs/tab_bar_widget.dart';
import 'package:flutter_base/widget/tabs/tabs_widget.dart';

class HomeTabsPage extends StatefulWidget {
  HomeTabsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeTabsPageState();
  }

  @override
  String toStringShort() {
    return '';
  }
}

class _HomeTabsPageState extends State<HomeTabsPage> {
  List<Widget> defaultTabViews = [
    GankListPage(),
    MovieListPage(),
  ];
  List<TabItem> defaultTabItems = <TabItem>[
    TabItem(text: 'GankGirl'),
    TabItem(text: 'Movie'),
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
  HomeProvider _homeProvider;

  @override
  void initState() {
    super.initState();
    _homeProvider = HomeProvider();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<HomeProvider>(
      model: _homeProvider,
      onModelInitial: (m) {
        //m.refresh();
      },
      builder: (context, model, childWidget) {
        Widget widget = buildDefaultTabs();
        //if (model.hasResponse()) {
        //  widget = initTabs(widget);
        //} else {
        //  if (model.refreshFailed) {
        //    widget = buildDefaultTabs();
        //  } else if (model.getProvinceCount() == 0) {
        //    widget = Scaffold(
        //      appBar: AppBar(
        //        title: Text('武汉加油'),
        //      ),
        //      body: Center(
        //        child: CircularProgressIndicator(),
        //      ),
        //    );
        //  } else {
        //    widget = initTabs(widget);
        //  }
        //}
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: widget,
        );
      },
    );
  }

  Widget initTabs(Widget widget) {
    List<Widget> tabViews = [];
    List<TabItem> tabItems = [];

    widget = TabsWidget(
      type: TabsWidget.TOP_TAB,
      tabStyle: TabsStyle.textOnly,
      tabViews: tabViews,
      tabItems: tabItems,
      isScrollable: true,
      customIndicator: true,
      decoration: _decoration,
      title: Text("干货"),
    );
    return widget;
  }

  MaterialApp buildDefaultTabs() {
    return MaterialApp(
      home: TabsWidget(
        type: TabsWidget.TOP_TAB,
        tabStyle: TabsStyle.textOnly,
        tabViews: defaultTabViews,
        tabItems: defaultTabItems,
        isScrollable: true,
        customIndicator: true,
        decoration: _decoration,
        title: Text("干货"),
      ),
    );
  }
}
