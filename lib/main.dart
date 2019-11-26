import 'package:AFlutter/home/home_tabs_page.dart';
import 'package:AFlutter/state/test_provider_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/app_provider.dart';
import 'tabs/tab_bar_widget.dart';

void main() {
  runApp(StateDemoApp());
}

class StateDemoApp extends StatefulWidget {
  const StateDemoApp({
    Key key,
  }) : super(key: key);

  @override
  _StateDemoAppState createState() => _StateDemoAppState();
}

class _StateDemoAppState extends State<StateDemoApp> {
  AppProvider model;

  @override
  void initState() {
    super.initState();
    model = AppProvider(); //..loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => AppProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, counter, _) {
          return MaterialApp(
            title: 'Flutter provider',
            //home: TestProviderPage(),
            home: TabBarPageWidget(),
          );
        },
      ),
    );
  }
}
