import 'package:AFlutter/model/movie_view_model.dart';
import 'package:AFlutter/page/base_list_state.dart';
import 'package:AFlutter/page/movie/movie_list_item.dart';
import 'package:AFlutter/widget/list/pull_widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TestListPage extends StatefulWidget {
  TestListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestListPageState();
  }
}

class _TestListPageState extends State<TestListPage>
    with BaseListState<TestListPage>, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print("initState");
    refreshController = new RefreshController(initialRefresh: true);
    viewModel = new MovieViewModel();
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return PullWidget(
      pullController: refreshController,
      listCount: viewModel.getCount(),
      itemBuilder: (BuildContext context, int index) =>
          _renderItem(context, index),
      header: MaterialClassicHeader(),
      onLoadMore: loadMore,
      onRefresh: refresh,
    );
  }

  //列表的ltem
  _renderItem(context, index) {
    return MovieListItem(bean: viewModel.data[index]);
  }
}
