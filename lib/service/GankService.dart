import 'dart:async';
import 'dart:convert';

import 'package:AFlutter/api/http_client.dart';
import 'package:AFlutter/api/http_response.dart';
import 'package:AFlutter/entity/gank_list_bean.dart';
import 'package:flutter/foundation.dart';

class GankService {
  static String dataURL = "http://gank.io/api/data/福利/%s/%s";

  //加载列表数据
  static Future<GankListBean> loadData({int pn}) async {
    pn ??= 0;
    GankListBean data;

    try {
      String url = "http://gank.io/api/data/福利/15/$pn";
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      //print("result:${httpResponse.data}");
      data = decodeListResult(httpResponse.data as String);
    } catch (e) {
      print(e);
    }
    return data;
  }

  static GankListBean decodeListResult(String result) {
    return GankListBean.fromJson(json.decode(result));
  }

  static Future<GankListBean> loadMore(int pn) async {
    return loadData(pn: pn);
  }
}
