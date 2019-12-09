import 'package:AFlutter/model/test_model.dart';
import 'package:AFlutter/page/first_provider_page.dart';
import 'package:AFlutter/state/test_provider_page.dart';
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
  TestProvider model;

  @override
  void initState() {
    super.initState();
    model = TestProvider(); //..loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    //return MultiProvider(
    //  providers: [
    //    ChangeNotifierProvider(builder: (_) => AppProvider()),
    //  ],
    //  child: Consumer<AppProvider>(
    //    builder: (context, counter, _) {
    //      return MaterialApp(
    //        title: 'Flutter provider',
    //        //home: TestProviderPage(),
    //        home: TabBarPageWidget(),
    //      );
    //    },
    //  ),
    //);
    return MaterialApp(
      title: 'Flutter provider',
      home: FirstProviderPage(),
      //home: TabBarPageWidget(),
    );
  }
}
