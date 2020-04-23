import 'package:AFlutter/entity/gank_category.dart';
import 'package:AFlutter/entity/gank_response.dart';
import 'package:AFlutter/repository/gank_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/base_list_view_model.dart';

class HomeProvider extends BaseListViewModel with ChangeNotifier {
  GankRepository _gankResposity;

  bool refreshFailed = false;

  HomeProvider() {
    _gankResposity = GankRepository.singleton;
  }

  int getCount() {
    return data == null ? 0 : data.length;
  }

  Future loadCategories() async {
    GankResponse<GankCategory> _gankResponse =
        await _gankResposity.loadCategories();
    print("refresh:$_gankResposity,$_gankResponse");
    if (_gankResponse == null || _gankResponse.data == null) {
      refreshFailed = true;
      notifyListeners();
      return;
    }
    refreshFailed = false;

    notifyListeners();
    print("refresh end:$_gankResponse");
  }

  Future loadMore(int pn) async {}

  Future loadMoreGank() async {
    notifyListeners();
  }

  @override
  Future loadData(int pn) {
    return null;
  }
}
