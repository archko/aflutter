import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'home/home_tabs_page.dart';
import 'model/app_state_mode.dart';

void main() {
  runApp(ScropedModeApp());
}

class ScropedModeApp extends StatefulWidget {
  const ScropedModeApp({
    Key key,
  }) : super(key: key);

  @override
  _ScropedModeAppState createState() => _ScropedModeAppState();
}

class _ScropedModeAppState extends State<ScropedModeApp> {
  AppStateModel model;

  @override
  void initState() {
    super.initState();
    model = AppStateModel()..loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppStateModel>(
      model: model,
      child: MaterialApp(
        title: 'Flutter scoped mode',
        color: Colors.grey,
        builder: (BuildContext context, Widget child) {
          return child;
        },
      ),
    );
  }
}
