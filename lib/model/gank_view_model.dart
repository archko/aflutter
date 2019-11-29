import 'package:AFlutter/entity/gank_list_bean.dart';
import 'package:AFlutter/http/http_client.dart';
import 'package:AFlutter/http/http_response.dart';
import 'package:AFlutter/model/base_list_view_model.dart';
import 'package:AFlutter/service/gank_service.dart';
import 'package:flutter/foundation.dart';

class GankViewModel extends BaseListViewModel {
  GankViewModel({page}) : super();

  Future<GankListBean> loadData(int pn, {String type}) async {
    pn ??= 0;
    type ??= "福利";
    GankListBean data;

    try {
      String url = "http://gank.io/api/data/$type/15/$pn";
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      //print("result:${httpResponse.data}");
      data = await compute(
          GankService.decodeListResult, httpResponse.data as String);
    } catch (e) {
      print(e);
    }
    return data;
  }

  Future<GankListBean> loadMore(int pn, {String type}) async {
    return loadData(pn, type: type);
  }
}
