import 'package:AFlutter/entity/User.dart';
import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/redux/list_result.dart';
import 'package:AFlutter/redux/app_movie_reducer.dart';
import 'package:AFlutter/redux/theme_reducer.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class AppState {
  User user;
  ThemeData themeData;

  ListResult<Animate> movies;

  AppState({
    this.themeData,
    this.movies,
  }) {
    if (null == movies) {
      movies = ListResult([], ListStatus.initial, null);
    }
  }
}
