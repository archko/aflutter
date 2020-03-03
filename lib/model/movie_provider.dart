import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MovieProvider with ChangeNotifier {
  MovieViewModel viewModel;
  RefreshController refreshController;

  bool refreshFailed = false;

  MovieProvider({this.viewModel, this.refreshController}) {
    //refresh();
    viewModel.setPage(0);
  }

  Future refresh() async {
    print("refresh:$viewModel,$refreshController");
    List<Animate> list = await viewModel.loadData(0);
    viewModel.setData(list);
    if (list == null || list.length == 0) {
      refreshFailed = true;
      refreshController?.refreshCompleted();
      notifyListeners();
      return;
    }
    refreshFailed = false;
    if (list != null && list.length > 0) {
      refreshController?.refreshCompleted();
    } else {
      refreshController?.loadNoData();
    }

    notifyListeners();
  }

  Future loadMore() async {
    print("loadMore:$viewModel,$refreshController");
    List<Animate> list = await viewModel.loadData(viewModel.page + 1);
    if (list != null && list.length > 0) {
      viewModel.addData(list);

      viewModel.setPage(viewModel.page + 1);

      refreshController?.refreshCompleted();
    } else {
      if (list == null) {
        refreshController?.loadFailed();
      } else {
        refreshController?.resetNoData();
      }
    }

    notifyListeners();
  }
}
