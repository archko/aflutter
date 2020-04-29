import 'package:AFlutter/page/test/base_ball_page.dart';
import 'package:AFlutter/page/test/bezier_curve_page.dart';
import 'package:AFlutter/page/test/indicator_page.dart';
import 'package:AFlutter/page/test/indicator_self_page.dart';
import 'package:AFlutter/page/test/test_paint_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/widget/tabs/tabs_widget.dart';

class TestTabsPage extends StatefulWidget {
  TestTabsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestTabsPageState();
  }

  @override
  String toStringShort() {
    return '';
  }
}

class _TestTabsPageState extends State<TestTabsPage> {
  List<Widget> _defaultTabViews = [
    BezierCurvePage(),
    BaseBallPage(),
    IndicatorPage(),
    IndicatorSelfPage(),
    TestPaintPage(),
  ];
  List<TabItem> _defaultTabItems = <TabItem>[];
  ShapeDecoration _decoration = ShapeDecoration(
    shape: StadiumBorder(
          side: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ) +
        const StadiumBorder(
          side: BorderSide(
            color: Colors.transparent,
            width: 1.5,
          ),
        ),
  );

  @override
  void initState() {
    super.initState();
    for (Widget widget in _defaultTabViews) {
      _defaultTabItems.add(TabItem(text: widget.toStringShort()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultTabs();
  }

  Widget _buildDefaultTabs() {
    return TabsWidget(
      tabsViewStyle: TabsViewStyle.appbarTopTab,
      tabStyle: TabsStyle.textOnly,
      tabViews: _defaultTabViews,
      tabItems: _defaultTabItems,
      isScrollable: true,
      customIndicator: false,
      decoration: _decoration,
      backgroundColor: Theme.of(context).accentColor,
      title: Text("测试"),
    );
  }
}
