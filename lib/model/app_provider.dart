import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
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
    _animates = await loadData();
    notifyListeners();
  }

  loadData() async {
    List<Animate> list = await MovieViewModel().loadData(0);
    return list;
  }
}
