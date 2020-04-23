import 'package:AFlutter/entity/gank_list_bean.dart';
import 'package:AFlutter/repository/gank_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/base_list_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GankProvider extends BaseListViewModel with ChangeNotifier {
  GankRepository _gankResposity;
  RefreshController refreshController;

  String from;
  String day;
  String cateid;

  bool refreshFailed = false;

  GankProvider({
    this.from,
    this.cateid,
    this.day,
    this.refreshController,
  }) {
    _gankResposity = GankRepository.singleton;
  }

  int getCount() {
    return data == null ? 0 : data.length;
  }

  Future refresh() async {
    GankListBean gankListBean = await _gankResposity.loadGankListBean();
    print("refresh:$_gankResposity,$gankListBean");
    data = gankListBean.beans;
    if (gankListBean == null ||
        gankListBean.beans == null ||
        gankListBean.beans.length == 0) {
      refreshFailed = true;
      refreshController?.refreshCompleted();
      notifyListeners();
      return;
    }
    refreshFailed = false;
    if (gankListBean.beans.length > 0) {
      refreshController?.refreshCompleted();
    } else {
      refreshController?.loadNoData();
    }

    notifyListeners();
    print("refresh end:$gankListBean");
  }

  Future loadMore(int pn) async {
    GankListBean gankListBean =
        await _gankResposity.loadMoreGankListBean("", page + 1);
    if (gankListBean != null &&
        gankListBean.beans != null &&
        gankListBean.beans.length > 0) {
      data.addAll(gankListBean.beans);

      page += 1;

      refreshController?.loadComplete();
    } else {
      if (gankListBean.beans == null) {
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
