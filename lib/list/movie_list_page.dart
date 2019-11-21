import 'dart:convert';

import 'package:AFlutter/api/http_client.dart';
import 'package:AFlutter/api/http_response.dart';
import 'package:AFlutter/state/load_model.dart';
import 'package:flutter/material.dart';

import 'movie_list_item.dart';
import 'pull_to_refresh_widget.dart';

class MovieListPage extends StatefulWidget {
  MovieListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MovieListPageState();
  }
}

class MovieListPageState extends State<MovieListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  LoadModel loadModel = new LoadModel();

  @override
  void initState() {
    super.initState();

    //加载第一页数据
    loadData();
  }

  //加载列表数据
  Future<Null> loadData() async {
    final String url =
        'https://sp0.baidu.com/8aQDcjqpAAV3otqbppnN2DJv/api.php?resource_id=28286&from_mid=1&&format=json&ie=utf-8&oe=utf-8&query=电影&sort_key=16&sort_type=1&stat0=&stat1=&stat2=&stat3=&pn=${loadModel
        .page}&rn=12&cb=cbs';
    try {
      /*var response = await new Dio().get<String>(url);
      var result = response.data.replaceAll('cbs(', '').replaceAll(')', '');
      List res = json.decode(result)['data'][0]['result'];

      setState(() {
        loadModel.setPage(loadModel.page + 1);
        loadModel.addDataList(
            (res.map((dynamic json) => Animate.fromJson(json)).toList()));
      });*/
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      setState(() {
        if (mounted) {
          print("result:${httpResponse}");
          var result =
          httpResponse.data.replaceAll('cbs(', '').replaceAll(')', '');
          List res = json.decode(result)['data'][0]['result'];
          List mlists = res.map((dynamic json) => Animate.fromJson(json))
              .toList();
          loadModel.addDataList(mlists);
        }
      });
    } catch (e) {
      print(e);
    }
    return null;
  }

  //下拉刷新,必须异步async不然会报错
  Future _pullToRefresh() async {
    loadModel.setPage(0);
    return loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new PullToRefreshWidget(
      loadModel: loadModel,
      itemBuilder: (BuildContext context, int index) =>
          _renderItem(index, context),
      onLoadMore: loadData,
      onRefresh: _pullToRefresh,
    );
    /*return new Scaffold(
      body: mlists.length == 0
          ? new Center(child: new CircularProgressIndicator())
          : new RefreshIndicator(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: mlists.length,
                itemBuilder: (context, index) {
                  return _renderItem(index, context);
                },
                controller: _scrollController, //指明控制器加载更多使用
              ),
              onRefresh: _pullToRefresh,
            ),
    );*/
  }

  /**
   * 列表的ltem
   */
  _renderItem(index, context) {
    return new MovieListItem(bean: loadModel.dataList[index]);
  }
}

class Animate {
  Animate({
    this.additional,
    this.ename,
    this.jumplink,
    this.jumpquery,
    this.kg_pic_url,
    this.name,
    this.pic_6n_161,
    this.searchp,
    this.selpic,
    this.sort,
    this.statctl,
    this.statlst,
  });

  factory Animate.fromJson(Map<String, dynamic> json) {
    return Animate(
      additional: json['additional'],
      ename: json['ename'],
      jumplink: json['jumplink'],
      jumpquery: json['jumpquery'],
      kg_pic_url: json['kg_pic_url'],
      name: json['name'],
      pic_6n_161: json['pic_6n_161'],
      searchp: json['searchp'],
      selpic: json['selpic'],
      sort: json['sort'],
      statctl: json['statctl'],
      statlst: json['statlst'],
    );
  }

  final String additional;
  final String ename;
  final String jumplink;
  final String jumpquery;
  final String kg_pic_url;
  final String name;
  final String pic_6n_161;
  final String searchp;
  final String selpic;
  final String sort;
  final String statctl;
  final String statlst;
}
