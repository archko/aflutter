import 'package:AFlutter/entity/gank_bean.dart';
import 'package:AFlutter/entity/gank_response.dart';
import 'package:AFlutter/repository/gank_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/base_list_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GankProvider extends BaseListViewModel with ChangeNotifier {
  GankRepository _gankResposity;
  RefreshController refreshController;

  String category;
  String type;

  bool refreshFailed = false;
  GankResponse<List<GankBean>> gankResponse;

  GankProvider({
    this.category,
    this.type,
    this.refreshController,
  }) {
    page = 1;
    _gankResposity = GankRepository.singleton;
  }

  int getCount() {
    return data == null ? 0 : data.length;
  }

  @override
  Future loadData({int pn}) async {
    GankResponse<List<GankBean>> _gankResponse = await _gankResposity
        .loadGankResponse(category: category, type: type, pn: page);
    print("refresh:$_gankResposity,$_gankResponse");
    if (_gankResponse == null ||
        _gankResponse.data == null ||
        _gankResponse.data.length == 0) {
      refreshFailed = true;
      refreshController?.refreshCompleted();
      notifyListeners();
      return;
    }
    gankResponse = _gankResponse;
    data = _gankResponse.data;
    refreshFailed = false;
    if (_gankResponse.data.length > 0) {
      refreshController?.refreshCompleted();
    } else {
      refreshController?.loadNoData();
    }

    notifyListeners();
    print("refresh end:$_gankResponse");
  }

  Future loadMore({int pn}) async {
    GankResponse _gankResponse =
        await _gankResposity.loadMoreGankResponse(category, type, page + 1);
    if (_gankResponse != null &&
        _gankResponse.data != null &&
        _gankResponse.data.length > 0) {
      data.addAll(_gankResponse.data);

      gankResponse.total_counts = _gankResponse.total_counts;
      page += 1;

      if (data.length == gankResponse.total_counts) {
        refreshController?.resetNoData();
      } else {
        refreshController?.loadComplete();
      }
    } else {
      if (_gankResponse.data == null) {
        refreshController?.loadFailed();
      } else {
        refreshController?.resetNoData();
      }
    }

    notifyListeners();
  }
}
