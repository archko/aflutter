import 'package:AFlutter/dao/MovieDao.dart';
import 'package:AFlutter/model/base_list_view_model.dart';
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
  BaseListViewModel loadModel = new BaseListViewModel();

  @override
  void initState() {
    super.initState();

    //加载第一页数据
    MovieDao.loadData();
  }

  //下拉刷新,必须异步async不然会报错
  Future _pullToRefresh() async {
    loadModel.setPage(0);
    return MovieDao.loadData();
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

  Future<void> loadData() {
    MovieDao.loadMore(loadModel.page);
  }
}
