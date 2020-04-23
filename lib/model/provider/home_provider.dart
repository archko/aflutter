import 'package:AFlutter/entity/gank_category.dart';
import 'package:AFlutter/entity/gank_response.dart';
import 'package:AFlutter/repository/gank_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/base_list_view_model.dart';

class HomeProvider extends BaseListViewModel with ChangeNotifier {
  GankRepository _gankResposity;

  int loadStatus = 0;
  String category_type;

  HomeProvider(this.category_type) {
    _gankResposity = GankRepository.singleton;
  }

  int getCount() {
    return data == null ? 0 : data.length;
  }

  Future loadCategories() async {
    GankResponse<List<GankCategory>> _gankResponse =
        await _gankResposity.loadCategories(category_type: category_type);
    print("refresh:$_gankResposity,$_gankResponse");
    if (_gankResponse == null || _gankResponse.data == null) {
      loadStatus = -1;
      notifyListeners();
      return;
    }
    data = _gankResponse.data;
    loadStatus = 1;

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
