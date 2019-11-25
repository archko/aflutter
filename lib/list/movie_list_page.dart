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
    return MovieListPageState();
  }
}

class MovieListPageState extends State<MovieListPage>
    with ListState<MovieListPage>, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  BaseListViewModel loadModel = BaseListViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loadModel.getCount() < 1 && loadMoreStatus == LoadMoreStatus.IDLE) {
      refresh();
    }
    return PullToRefreshWidget(
      itemBuilder: (BuildContext context, int index) =>
          _renderItem(index, context),
      listCount: loadModel.getCount(),
      onLoadMore: loadMore,
      onRefresh: refresh,
      listState: this,
    );
    /*return Scaffold(
      body: mlists.length == 0
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
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
    return MovieListItem(bean: loadModel.dataList[index]);
  }

  @override
  Future refresh() async {
    setStatus(LoadMoreStatus.LOADING);
    loadModel.setPage(0);
    await MovieService.loadData().then((list) {
      loadModel.setDataList(list);
      setState(() {
        print("refresh end.${loadModel.page}, ${loadModel.getCount()}");
        if (list.length < 1) {
          setStatus(LoadMoreStatus.NOMORE);
        } else {
          setStatus(LoadMoreStatus.IDLE);
        }
      });
    }).catchError((_) => setState(() {
          print("refresh error");
          setStatus(LoadMoreStatus.FAIL);
        }));
  }

  @override
  Future<void> loadMore() async {
    if (loadModel.getCount() < 1) {
      return refresh();
    }
    setStatus(LoadMoreStatus.LOADING);
    await MovieService.loadMore(loadModel.page + 1).then((list) {
      loadModel.addDataList(list);
      loadModel.setPage(loadModel.page + 1);
      setState(() {
        if (list.length < 1) {
          setStatus(LoadMoreStatus.NOMORE);
        } else {
          setStatus(LoadMoreStatus.IDLE);
        }
        print("loadMore end.${loadModel.page}, ${loadModel.getCount()}");
      });
    }).catchError((_) => setState(() {
          setStatus(LoadMoreStatus.FAIL);
        }));
  }
}
