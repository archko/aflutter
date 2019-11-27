import 'package:AFlutter/model/base_list_view_model.dart';
import 'package:AFlutter/service/MovieService.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'movie_list_item.dart';
import 'pull_widget.dart';

class TestListPage extends StatefulWidget {
  TestListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestListPageState();
  }
}

class TestListPageState extends State<TestListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  BaseListViewModel loadModel = BaseListViewModel();
  RefreshController _refreshController =
      new RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PullWidget(
      pullController: _refreshController,
      listCount: loadModel.getCount(),
      itemBuilder: (BuildContext context, int index) =>
          _renderItem(context, index),
      header: MaterialClassicHeader(),
      onLoadMore: loadMore,
      onRefresh: refresh,
    );
  }

  //列表的ltem
  _renderItem(context, index) {
    return MovieListItem(bean: loadModel.data[index]);
  }

  Future refresh() async {
    loadModel.setPage(0);
    await MovieService.loadData().then((list) {
      loadModel.setData(list);
      setState(() {
        print("refresh end.${loadModel.page}, ${loadModel.getCount()}");
        if (list.length < 1) {
          _refreshController.loadNoData();
        } else {
          _refreshController.refreshCompleted(resetFooterState: true);
        }
      });
    }).catchError((_) => setState(() {
          print("refresh error");
          _refreshController.loadFailed();
        }));
  }

  Future<void> loadMore() async {
    if (loadModel.getCount() < 1) {
      return refresh();
    }

    await MovieService.loadMore(loadModel.page + 1).then((list) {
      loadModel.updateDataAndPage(list, loadModel.page + 1);
      setState(() {
        if (list.length < 1) {
          _refreshController.loadNoData();
        } else {
          _refreshController.refreshCompleted(resetFooterState: true);
        }
        print(
            "loadMore end.${_refreshController.footerStatus},${loadModel.page}, ${loadModel.getCount()}");
      });
    }).catchError((_) => setState(() {
          _refreshController.loadFailed();
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
