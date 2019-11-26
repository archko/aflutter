import 'package:AFlutter/tabs/tab_bar_widget.dart';
import 'package:flutter/material.dart';

class HomeTabsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Home',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        //primaryColor: Colors.white,
      ),
      home: new TabBarPageWidget(),
    );
  }
}
