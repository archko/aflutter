import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/base_list_view_model.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TestProvider with ChangeNotifier {
  MovieViewModel viewModel;
  RefreshController refreshController;

  TestProvider({this.viewModel, this.refreshController}) {
    //refresh();
  }

  List<Animate> getMovies() {
    //print("get:${viewModel?.getCount()}");
    return viewModel?.getData();
  }

  Future refresh() async {
    print("refresh:$viewModel,$refreshController");
    List<Animate> list = await viewModel.loadData(0);
    viewModel.setData(list);
    if (list != null && list.length > 0) {
      if (list.length < 1) {
        refreshController?.loadNoData();
      } else {
        refreshController?.refreshCompleted();
      }
    }

    notifyListeners();
  }

  Future loadMore() async {
    List<Animate> list = await viewModel.loadMore(1);
    viewModel.addData(list);
    if (list == null || list.length < 1) {
      refreshController?.loadNoData();
    } else {
      refreshController?.loadComplete();
    }

    notifyListeners();
  }

  void clear() {
    viewModel.getData().clear();
    notifyListeners();
  }
}
