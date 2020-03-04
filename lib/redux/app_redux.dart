import 'package:AFlutter/entity/User.dart';
import 'package:AFlutter/redux/theme_reducer.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class AppState {
  User user;
  ThemeData themeData;

  AppState({this.themeData});
}

AppState appReducer(AppState appState, action) {
  return AppState(themeData: themeDataReducer(appState.themeData, action));
}

final List<Middleware<AppState>> middleware = [];
