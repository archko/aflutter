import 'dart:convert';

import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/entity/gank_list_bean.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base/http/http_client.dart';
import 'package:flutter_base/http/http_response.dart';

class GankRepository {
  static final GankRepository _instance = GankRepository();

  static GankRepository get singleton => _instance;

  static String dataURL = "http://gank.io/api/data/福利/%s/%s";

  //加载列表数据
  Future<GankListBean> loadGankListBean({String type, int pn}) async {
    pn ??= 0;
    type ??= "福利";
    GankListBean data;

    try {
      String url = "http://gank.io/api/data/$type/15/$pn";
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

  Future<GankListBean> loadMoreGankListBean(String type, int pn) async {
    return loadGankListBean(type: type, pn: pn);
  }

  ///=============================
  //加载列表数据
  Future<List<Animate>> loadMovie({int pn}) async {
    pn ??= 0;
    List<Animate> list;
    String url =
        'https://sp0.baidu.com/8aQDcjqpAAV3otqbppnN2DJv/api.php?resource_id=28286&from_mid=1&&format=json&ie=utf-8&oe=utf-8&query=电影&sort_key=16&sort_type=1&stat0=&stat1=&stat2=&stat3=&pn=$pn&rn=6&cb=cbs';
    try {
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      String result =
          httpResponse.data.replaceAll('cbs(', '').replaceAll(')', '');
      //print("result:$result");
      list = await compute(decodeMovieListResult, result);
    } catch (e) {
      print(e);
    }
    return list;
  }

  static List<Animate> decodeMovieListResult(String result) {
    //return json.decode(data);
    return json
        .decode(result)['data'][0]['result']
        .map<Animate>((dynamic json) => Animate.fromJson(json))
        .toList();
  }

  Future<List<Animate>> loadMoreMovie(int pn) async {
    return loadMovie(pn: pn);
  }
}
