import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'state/app_redux.dart';
import 'state/test_flutter_redux_page.dart';

void main() {
  final store = Store<SearchState>(
    searchReducer,
    initialState: SearchInitial(),
    middleware: [
      SearchMiddleware(),
    ],
  );

  runApp(StateDemoApp(
    store: store,
  ));
}

class StateDemoApp extends StatelessWidget {
  const StateDemoApp({
    Key key,
    this.store,
  }) : super(key: key);

  final Store store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<SearchState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter redux',
        home: TestFlutterReduxPage(),
      ),
    );
  }
}
