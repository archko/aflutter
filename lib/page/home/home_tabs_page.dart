import 'package:AFlutter/entity/gank_category.dart';
import 'package:AFlutter/model/provider/home_provider.dart';
import 'package:AFlutter/page/list/gank_list_page.dart';
import 'package:AFlutter/page/movie/movie_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/provider_widget.dart';
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
  String categoryType = "Article";

  @override
  void initState() {
    super.initState();
    _homeProvider = HomeProvider(categoryType);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<HomeProvider>(
      model: _homeProvider,
      onModelInitial: (m) {
        m.loadCategories();
        //m.refresh();
      },
      builder: (context, model, childWidget) {
        Widget widget;
        if (model.loadStatus == 0) {
          widget = Scaffold(
            appBar: AppBar(
              title: Text('干货'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (model.loadStatus == 1) {
          widget = initTabs(model.data);
        } else {
          widget = buildDefaultTabs();
        }

        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: widget,
        );
      },
    );
  }

  Widget initTabs(List<GankCategory> list) {
    List<Widget> tabViews = [];
    List<TabItem> tabItems = [];
    bool hasGirl = false;
    for (GankCategory category in list) {
      tabViews
          .add(GankListPage(category: category, categoryType: categoryType));
      tabItems.add(TabItem(text: category.title));
      if ("Girl" == category.title) {
        hasGirl = true;
      }
    }

    if (!hasGirl) {
      tabViews.insert(
          0,
          GankListPage(
              category: GankCategory(title: "Girl"),
              categoryType: "Girl"));
      tabItems.insert(0, TabItem(text: 'Girl'));
    }

    return TabsWidget(
      type: TabsWidget.TOP_TAB,
      tabStyle: TabsStyle.textOnly,
      tabViews: tabViews,
      tabItems: tabItems,
      isScrollable: true,
      customIndicator: true,
      decoration: _decoration,
      title: Text("干货"),
    );
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
