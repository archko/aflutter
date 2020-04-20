import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/home/home_tabs_page.dart';
import 'package:AFlutter/redux/list_result.dart';
import 'package:AFlutter/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    this.store,
  }) : super(key: key);

  final Store store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<ListResult<Animate>>(
      store: store,
      child: MaterialApp(
        //title: 'Flutter redux',
        home: HomeTabsPage(),
      ),
    );
  }
}

class ThemeApp extends StatelessWidget {
  const ThemeApp({
    Key key,
    this.store,
  }) : super(key: key);

  final Store store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: StoreBuilder<AppState>(
        builder: (context, store) {
          return MaterialApp(
            //title: 'Flutter redux',
            home: HomeTabsPage(),
            //home: ThemeReduxPage(),
            theme: store.state.themeData,
          );
        },
      ),
    );
  }
}
