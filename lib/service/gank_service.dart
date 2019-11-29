import 'dart:convert';

import 'package:AFlutter/entity/gank_list_bean.dart';

class GankService {
  static String dataURL = "http://gank.io/api/data/福利/%s/%s";

  //加载列表数据
  //static Future<GankListBean> loadData({String type, int pn}) async {
  //  pn ??= 0;
  //  type ??= "福利";
  //  GankListBean data;
//
  //  try {
  //    String url = "http://gank.io/api/data/$type/15/$pn";
  //    HttpResponse httpResponse = await HttpClient.instance.get(url);
  //    //print("result:${httpResponse.data}");
  //    data = decodeListResult(httpResponse.data as String);
  //  } catch (e) {
  //    print(e);
  //  }
  //  return data;
  //}

  static GankListBean decodeListResult(String result) {
    return GankListBean.fromJson(json.decode(result));
  }

  //static Future<GankListBean> loadMore(String type, int pn) async {
  //  return loadData(type: type, pn: pn);
  //}
}
