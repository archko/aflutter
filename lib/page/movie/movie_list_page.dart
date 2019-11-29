import 'package:AFlutter/model/base_list_view_model.dart';
import 'package:AFlutter/page/movie/movie_list_item.dart';
import 'package:AFlutter/service/movie_service.dart';
import 'package:AFlutter/widget/list/list_more_widget.dart';
import 'package:AFlutter/widget/list/pull_to_refresh_widget.dart';
import 'package:flutter/material.dart';

class MovieListPage extends StatefulWidget {
  MovieListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MovieListPageState();
  }
}

class MovieListPageState extends State<MovieListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  BaseListViewModel loadModel = BaseListViewModel();
  var loadMoreStatus = LoadMoreStatus.IDLE;

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
      listCount: loadModel.getCount() + 1,
      onLoadMore: loadMore,
      onRefresh: refresh,
      loadMoreStatus: loadMoreStatus,
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
    //
    if (index == loadModel.getCount()) {
      return ListMoreWidget(
        loadMoreStatus: loadMoreStatus,
        retry: retry,
      );
    } else {
      return MovieListItem(bean: loadModel.data[index]);
    }
  }

  Future refresh() async {
    loadMoreStatus = (LoadMoreStatus.LOADING);
    loadModel.setPage(0);
    await MovieService.loadData().then((list) {
      loadModel.setData(list);
      setState(() {
        print("refresh end.${loadModel.page}, ${loadModel.getCount()}");
        if (list.length < 1) {
          loadMoreStatus = (LoadMoreStatus.NOMORE);
        } else {
          loadMoreStatus = (LoadMoreStatus.IDLE);
        }
      });
    }).catchError((_) => setState(() {
          print("refresh error");
          loadMoreStatus = (LoadMoreStatus.FAIL);
        }));
  }

  Future<void> loadMore() async {
    if (loadModel.getCount() < 1) {
      return refresh();
    }
    setState(() {
      loadMoreStatus = (LoadMoreStatus.LOADING);
    });
    await MovieService.loadMore(loadModel.page + 1).then((list) {
      loadModel.updateDataAndPage(list, loadModel.page + 1);
      setState(() {
        if (list.length < 1) {
          loadMoreStatus = (LoadMoreStatus.NOMORE);
        } else {
          loadMoreStatus = (LoadMoreStatus.IDLE);
        }
        print(
            "loadMore end.$loadMoreStatus,${loadModel.page}, ${loadModel.getCount()}");
      });
    }).catchError((_) => setState(() {
          loadMoreStatus = (LoadMoreStatus.FAIL);
        }));
  }

  retry() {
    if (loadModel.getCount() < 1) {
      refresh();
    } else {
      loadMore();
    }
  }
}
