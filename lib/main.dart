import 'package:AFlutter/entity/animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'state/app_redux.dart';
import 'state/test_flutter_redux_page.dart';

void main() {
  runReduxApp();
}

void runReduxApp() {
  final store = Store<ListState<Animate>>(
    listReducer,
    initialState: ListInitialState(),
    middleware: [
      ListMiddleware(),
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
        title: 'Flutter redux',
        home: TestFlutterReduxPage(),
      ),
    );
  }
}
