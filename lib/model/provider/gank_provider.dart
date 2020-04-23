import 'package:AFlutter/entity/gank_bean.dart';
import 'package:AFlutter/entity/gank_response.dart';
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
    page = 0;
    _gankResposity = GankRepository.singleton;
  }

  int getCount() {
    return data == null ? 0 : data.length;
  }

  Future refresh() async {
    GankResponse<List<GankBean>> _gankResponse =
        await _gankResposity.loadGankResponse();
    print("refresh:$_gankResposity,$_gankResponse");
    data = _gankResponse.data;
    if (_gankResponse == null ||
        _gankResponse.data == null ||
        _gankResponse.data.length == 0) {
      refreshFailed = true;
      refreshController?.refreshCompleted();
      notifyListeners();
      return;
    }
    refreshFailed = false;
    if (_gankResponse.data.length > 0) {
      refreshController?.refreshCompleted();
    } else {
      refreshController?.loadNoData();
    }

    notifyListeners();
    print("refresh end:$_gankResponse");
  }

  Future loadMore(int pn) async {}

  Future loadMoreGank() async {
    GankResponse _gankResponse =
        await _gankResposity.loadMoreGankResponse("Girl", "Girl", page + 1);
    if (_gankResponse != null &&
        _gankResponse.data != null &&
        _gankResponse.data.length > 0) {
      data.addAll(_gankResponse.data);

      page += 1;

      refreshController?.loadComplete();
    } else {
      if (_gankResponse.data == null) {
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
