import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/home/home_tabs_page.dart';
import 'package:AFlutter/middleware/app_movie_middleware.dart';
import 'package:AFlutter/middleware/movie_middleware.dart';
import 'package:AFlutter/redux/app_list_redux.dart';
import 'package:AFlutter/redux/app_movie_reducer.dart';
import 'package:AFlutter/redux/app_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  //runReduxApp();
  runThemeApp();
}

void runReduxApp() {
  final store = Store<ListState<Animate>>(
    listReducer,
    initialState: ListInitialState(),
    middleware: [
      ListMiddleware(),
      MovieMiddleware(),
    ],
  );

  runApp(FlutterReduxDemoApp(
    store: store,
  ));
}

class FlutterReduxDemoApp extends StatelessWidget {
  const FlutterReduxDemoApp({
    Key key,
    this.store,
  }) : super(key: key);

  final Store store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<ListState<Animate>>(
      store: store,
      child: MaterialApp(
        //title: 'Flutter redux',
        home: HomeTabsPage(),
      ),
    );
  }
}

/// =============================
void runThemeApp() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(themeData: ThemeData(primarySwatch: Colors.red)),
    middleware: middleware,
  );

  runApp(ThemeApp(
    store: store,
  ));
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
