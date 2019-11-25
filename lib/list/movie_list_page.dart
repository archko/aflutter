import 'package:AFlutter/service/MovieService.dart';
import 'package:AFlutter/entity/Animate.dart';
import 'package:AFlutter/model/base_list_view_model.dart';
import 'package:AFlutter/state/list_state.dart';
import 'package:AFlutter/state/load_more_status.dart';
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
    with ListState<MovieListPage>, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  BaseListViewModel loadModel = new BaseListViewModel();

  @override
  void initState() {
    super.initState();

    //加载第一页数据
    //MovieService.loadData();
  }

  //下拉刷新,必须异步async不然会报错
  @override
  Future refresh() async {
    setStatus(LoadMoreStatus.LOADING);
    loadModel.setPage(0);
    List<Animate> list = await MovieService.loadData();
    loadModel.setDataList(list);
    setState(() {
      setStatus(LoadMoreStatus.IDLE);
      print("refresh end.${loadModel.page}, ${loadModel.getCount()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new PullToRefreshWidget(
      itemBuilder: (BuildContext context, int index) =>
          _renderItem(index, context),
      listCount: loadModel.getCount(),
      onLoadMore: loadMore,
      onRefresh: refresh,
      listState: this,
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

  @override
  Future<void> loadMore() async {
    if (loadModel.getCount() < 1) {
      return refresh();
    }
    setStatus(LoadMoreStatus.LOADING);
    List<Animate> list = await MovieService.loadMore(loadModel.page);
    loadModel.addDataList(list);
    loadModel.setPage(loadModel.page + 1);
    setState(() {
      setStatus(LoadMoreStatus.IDLE);
      print("loadMore end.${loadModel.page}, ${loadModel.getCount()}");
    });
  }
}
