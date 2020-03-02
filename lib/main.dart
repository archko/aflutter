import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/middleware/app_movie_middleware.dart';
import 'package:AFlutter/page/movie_flutter_redux_page.dart';
import 'package:AFlutter/redux/app_movie_reducer.dart';
import 'package:AFlutter/redux/app_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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
        home: MovieFlutterReduxPage(),
      ),
    );
  }
}
