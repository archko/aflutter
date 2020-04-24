import 'package:AFlutter/entity/gank_banner.dart';
import 'package:AFlutter/entity/gank_category.dart';
import 'package:AFlutter/entity/gank_response.dart';
import 'package:AFlutter/repository/gank_repository.dart';
import 'package:flutter_base/widget/banner/custom_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/base_list_view_model.dart';

class HomeProvider extends BaseListViewModel with ChangeNotifier {
  GankRepository _gankResposity;

  int loadStatus = 0;
  String categoryType;
  GankResponse<List<GankBanner>> gankBannerResponse;

  HomeProvider(this.categoryType) {
    _gankResposity = GankRepository.singleton;
  }

  int getCount() {
    return data == null ? 0 : data.length;
  }

  Future loadCategories() async {
    GankResponse<List<GankCategory>> _gankResponse =
        await _gankResposity.loadCategories(categoryType: categoryType);
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

  Future loadBanner() async {
    GankResponse<List<GankBanner>> _gankResponse =
        await _gankResposity.loadBanners();
    gankBannerResponse = _gankResponse;

    notifyListeners();
  }

  List<BannerBean> getBannerBeans() {
    if (gankBannerResponse == null ||
        gankBannerResponse.data == null ||
        gankBannerResponse.data.length == 0) {
      return [];
    }
    List<BannerBean> banners = [];
    for (var banner in gankBannerResponse.data) {
      banners.add(BannerBean(imageUrl: banner.image, title: banner.title));
    }
    return banners;
  }

  @override
  Future loadData(int pn) {
    return null;
  }
}
