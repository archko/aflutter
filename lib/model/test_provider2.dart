import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:flutter/material.dart';

class TestProvider2 with ChangeNotifier {
  MovieViewModel _viewModel = MovieViewModel();
  List<Animate> _animates;

  List<Animate> getMovies() {
    if (_animates == null) {
      return <Animate>[];
    }

    return _animates;
  }

  void loadMovies() async {
    _animates = await _viewModel.loadData(0);
    notifyListeners();
  }

  void clear() {
    _animates.clear();
    notifyListeners();
  }
}
