import 'dart:async';
import 'dart:io';

import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/entity/gank_banner.dart';
import 'package:AFlutter/entity/gank_bean.dart';
import 'package:AFlutter/entity/gank_category.dart';
import 'package:AFlutter/entity/gank_response.dart';
import 'package:flutter_base/http/http_client.dart';
import 'package:flutter_base/http/http_response.dart';
import 'package:flutter_base/utils/isolate_utils.dart';
import 'package:flutter_base/utils/json_utils.dart';

class GankRepository {
  static final GankRepository _instance = GankRepository();

  static GankRepository get singleton => _instance;

  /// 分类数据 API
  /// https://gank.io/api/v2/data/category/<category>/type/<type>/page/<page>/count/<count>
  /// 请求方式: GET
  /// 注:
  /// category 可接受参数 All(所有分类) | Article | GanHuo | Girl
  /// type 可接受参数 All(全部类型) | Android | iOS | Flutter | Girl ...，即分类API返回的类型数据
  /// count: [10, 50]
  /// page: >=1
  Future<GankResponse<List<GankBean>>> loadGankResponse(
      {String category, String type, int pn}) async {
    pn ??= 1;
    category ??= "Girl";
    type ??= "Girl";
    GankResponse<List<GankBean>> _gankResponse;

    String url =
        "https://gank.io/api/v2/data/category/$category/type/$type/page/$pn/count/15";
    try {
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      //_gankResponse =
      //    await compute(decodeGankList, httpResponse.data as String);

      _gankResponse = await decodeGankList(httpResponse.data as String);
    } catch (e) {
      print(e);
    }
    return _gankResponse;
  }

  /// 随机 API https://gank.io/api/v2/random/category/GanHuo/type/Android/count/10
  /// 请求方式: GET
  /// 注:
  /// category 可接受参数 Article | GanHuo | Girl
  /// type 可接受参数 Android | iOS | Flutter | Girl，即分类API返回的类型数据
  /// count: [1, 50]
  Future<GankResponse<List<GankBean>>> loadRandomGankList(
      {String category, String type, int pn}) async {
    category ??= "GanHuo";
    type ??= "Android";
    GankResponse<List<GankBean>> _gankResponse;

    try {
      String url =
          "https://gank.io/api/v2/random/category/$category/type/$type/count/15";
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      _gankResponse = await decodeGankList(httpResponse.data as String);
    } catch (e) {
      print(e);
    }
    return _gankResponse;
  }

  /// 文章详情 API https://gank.io/api/v2/post/<post_id>
  /// 请求方式: GET
  /// 注:
  /// post_id 可接受参数 文章id[分类数据API返回的_id字段]
  Future<GankResponse<GankBean>> loadGankDetail(String postId) async {
    GankResponse<GankBean> _gankResponse;

    try {
      String url = "https://gank.io/api/v2/post/$postId";
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      _gankResponse = await loadWithBalancer<GankResponse<GankBean>, String>(
          decodeGank, httpResponse.data as String);
    } catch (e) {
      print(e);
    }
    return _gankResponse;
  }

  /// 本周最热 API https://gank.io/api/v2/hot/<hot_type>/category/<category>/count/<count>
  /// 请求方式: GET
  /// 注:
  /// hot_type 可接受参数 views（浏览数） | likes（点赞数） | comments（评论数）❌
  /// category 可接受参数 Article | GanHuo | Girl
  /// count: [1, 20]
  Future<GankResponse<List<GankBean>>> loadWeekHotGankList(
      {String category, String hotType}) async {
    category ??= "Girl";
    hotType ??= "views";
    GankResponse<List<GankBean>> _gankResponse;

    try {
      String url =
          "https://gank.io/api/v2/hot/$hotType/category/$category/count/15";
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      _gankResponse = await decodeGankList(httpResponse.data as String);
    } catch (e) {
      print(e);
    }
    return _gankResponse;
  }

  /// 文章评论获取 API https://gank.io/api/v2/post/comments/<post_id>
  /// 请求方式: GET
  /// 注:
  /// post_id 可接受参数 文章Id
  Future<GankResponse<List<GankBean>>> loadGankCommentList(
      String postId) async {
    GankResponse<List<GankBean>> _gankResponse;

    try {
      String url = "https://gank.io/api/v2/post/comments/$postId";
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      _gankResponse = await decodeGankList(httpResponse.data as String);
    } catch (e) {
      print(e);
    }
    return _gankResponse;
  }

  /// 搜索 API https://gank.io/api/v2/search/<search>/category/<category>/type/<type>/page/<page>/count/<count>
  /// 请求方式: GET
  /// 注:
  /// search 可接受参数 要搜索的内容
  /// category 可接受参数 All[所有分类] | Article | GanHuo
  /// type 可接受参数 Android | iOS | Flutter ...，即分类API返回的类型数据
  /// count: [10, 50]
  /// page: >=1
  Future<GankResponse<List<GankBean>>> searchGank(
      String search, String category, String type, int page) async {
    GankResponse<List<GankBean>> _gankResponse;

    try {
      String url =
          "https://gank.io/api/v2/search/$search/category/$category/type/$type/page/$page/count/15";
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      _gankResponse = await decodeGankList(httpResponse.data as String);
    } catch (e) {
      print(e);
    }
    return _gankResponse;
  }

  Future loadMoreGankResponse(String category, String type, int pn) async {
    return loadGankResponse(category: category, type: type, pn: pn);
  }

  /// https://gank.io/api/v2/categories/<category_type> 请求方式: GET
  /// 注:获取所有分类具体子分类[types]数据
  /// category_type 可接受参数 Article | GanHuo | Girl
  /// Article: 专题分类、 GanHuo: 干货分类 、 Girl:妹子图
  Future<GankResponse<List<GankCategory>>> loadCategories(
      {String categoryType}) async {
    categoryType ??= "Article";
    GankResponse<List<GankCategory>> _gankResponse;
    try {
      String url = "https://gank.io/api/v2/categories/$categoryType";
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      _gankResponse =
          await loadWithBalancer<GankResponse<List<GankCategory>>, String>(
              decodeCategories, httpResponse.data as String);
    } catch (e) {
      print(e);
    }
    return _gankResponse;
  }

  /// 首页banner轮播 https://gank.io/api/v2/banners 请求方式: GET
  /// 注:返回首页banner轮播的数据
  Future loadBanners() async {
    GankResponse<List<GankBanner>> _gankResponse;
    try {
      String url = "https://gank.io/api/v2/banners";
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      _gankResponse =
          await loadWithBalancer<GankResponse<List<GankBanner>>, String>(
              decodeBanners, httpResponse.data as String);
    } catch (e) {
      print(e);
    }
    return _gankResponse;
  }

  GankResponse<GankBean> decodeGank(String result) {
    Map<String, dynamic> decode = JsonUtils.decodeAsMap(result);
    GankResponse<GankBean> response = GankResponse.fromJson(decode);
    if (decode.containsKey("data")) {
      var results = decode["data"];

      response.data = GankBean.fromJson(results);
    }
    return response;
  }

  Future<GankResponse<List<GankBean>>> decodeGankList(String data) async {
    GankResponse<List<GankBean>> _gankResponse =
        await loadWithBalancer<GankResponse<List<GankBean>>, String>(
            _doDecodeGankList, data);
    return _gankResponse;
  }

  /// need to be top level,or static
  static GankResponse<List<GankBean>> _doDecodeGankList(String result) {
    Map<String, dynamic> decode = JsonUtils.decodeAsMap(result);
    GankResponse<List<GankBean>> response = GankResponse.fromJson(decode);
    if (decode.containsKey("data")) {
      var results = decode["data"];
      List<GankBean> beans = List();
      for (var item in results) {
        //print("item:$item,");
        beans.add(GankBean.fromJson(item));
      }
      response.data = beans;
    }
    return response;
  }

  static GankResponse<List<GankCategory>> decodeCategories(String result) {
    Map<String, dynamic> decode = JsonUtils.decodeAsMap(result);
    GankResponse<List<GankCategory>> response = GankResponse.fromJson(decode);
    if (decode.containsKey("data")) {
      var results = decode["data"];
      List<GankCategory> beans = List();
      for (var item in results) {
        //print("item:$item,");
        beans.add(GankCategory.fromJson(item));
      }
      response.data = beans;
    }
    return response;
  }

  static GankResponse<List<GankBanner>> decodeBanners(String result) {
    Map<String, dynamic> decode = JsonUtils.decodeAsMap(result);
    GankResponse<List<GankBanner>> response = GankResponse.fromJson(decode);
    if (decode.containsKey("data")) {
      var results = decode["data"];
      List<GankBanner> beans = List();
      for (var item in results) {
        //print("item:$item,");
        beans.add(GankBanner.fromJson(item));
      }
      response.data = beans;
    }
    return response;
  }

  ///=============================
  /// 加载列表数据
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
      list = await loadWithBalancer<List<Animate>, String>(
          decodeMovieList, result);
    } catch (e) {
      print(e);
    }
    return list;
  }

  static List<Animate> decodeMovieList(String result) {
    return JsonUtils.decodeAsMap(result)['data'][0]['result']
        .map<Animate>((dynamic json) => Animate.fromJson(json))
        .toList();
  }

  Future<List<Animate>> loadMoreMovie(int pn) async {
    return loadMovie(pn: pn);
  }
}
