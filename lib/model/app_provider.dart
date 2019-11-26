import 'package:AFlutter/entity/Animate.dart';
import 'package:AFlutter/dao/MovieDao.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  List<Animate> _animates;

  List<Animate> getMovies() {
    if (_animates == null) {
      Future(() => {loadMovies()});
      return <Animate>[];
    }

    return _animates;
  }

  void loadMovies() async {
    _animates = await MovieDao.loadData();
    notifyListeners();
  }
}
