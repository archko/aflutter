import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/service/movie_service.dart';
import 'package:flutter/material.dart';

class TestModel with ChangeNotifier {
  List<Animate> _animates;

  List<Animate> getMovies() {
    if (_animates == null) {
      return <Animate>[];
    }

    return _animates;
  }

  void loadMovies() async {
    _animates = await MovieService.loadData();
    notifyListeners();
  }

  void clear() {
    _animates.clear();
    notifyListeners();
  }
}
