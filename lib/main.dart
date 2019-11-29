import 'package:AFlutter/model/app_provider.dart';
import 'package:AFlutter/widget/tabs/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
