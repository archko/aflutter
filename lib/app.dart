import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base/widget/tabs/tab_bar_widget.dart';

Widget createApp() {
  return StateDemoApp();
}

class StateDemoApp extends StatefulWidget {
  const StateDemoApp({
    Key key,
  }) : super(key: key);

  @override
  _StateDemoAppState createState() => _StateDemoAppState();
}

class _StateDemoAppState extends State<StateDemoApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter provider',
      //home: TestProviderPage(),
      home: TabBarPageWidget(),
    );
  }
}
