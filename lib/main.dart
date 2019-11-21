import 'package:AFlutter/state/test_provider_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/app_provider.dart';

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
            home: TestProviderModePage(),
          );
        },
      ),
    );
  }
}
