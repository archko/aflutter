import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/repository/gank_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/base_list_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MovieProvider extends BaseListViewModel with ChangeNotifier {
  GankRepository _gankResposity;
  RefreshController refreshController;

  bool refreshFailed = false;

  MovieProvider({this.refreshController}) {
    //refresh();
    _gankResposity = GankRepository.singleton;
  }

  Future refresh() async {
    print("refresh:${refreshController.footerStatus},$_gankResposity");
    List<Animate> list = await _gankResposity.loadMovie(pn: 0);
    setData(list);
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

  Future loadMore([int pn]) async {
    print("loadMore:${refreshController.footerStatus},$_gankResposity");
    List<Animate> list = await _gankResposity.loadMovie(pn: page + 1);
    if (list != null && list.length > 0) {
      addData(list);

      setPage(page + 1);

      refreshController?.loadComplete();
    } else {
      if (list == null) {
        refreshController?.loadFailed();
      } else {
        refreshController?.resetNoData();
      }
    }

    notifyListeners();
  }

  @override
  Future loadData(int pn) {
    return null;
  }
}
