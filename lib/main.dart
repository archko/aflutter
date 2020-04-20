import 'package:AFlutter/app.dart';
import 'package:AFlutter/middleware/app_movie_middleware.dart';
import 'package:AFlutter/redux/app_state_reducer.dart';
import 'package:AFlutter/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/log/logger.dart';
import 'package:redux/redux.dart';

void main() {
  Logger.init(debuggable: true);
  //runReduxApp();
  runThemeApp();
}

void runReduxApp() {
  /*final store = Store<ListState<Animate>>(
    listReducer,
    initialState: ListInitialState(),
    middleware: [
      ListMiddleware(),
      MovieMiddleware(),
    ],
  );

  runApp(FlutterReduxDemoApp(
    store: store,
  ));*/
}

void runThemeApp() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(themeData: ThemeData(primarySwatch: Colors.red)),
    middleware: createStoreMoviesMiddleware(),
  );

  runApp(ThemeApp(
    store: store,
  ));
}
