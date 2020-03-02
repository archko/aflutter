import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

import '../page/movie_list_item.dart';
import 'app_redux.dart';

class TestFlutterReduxPage extends StatefulWidget {
  TestFlutterReduxPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TestFlutterReduxPageState();
  }
}

class TestFlutterReduxPageState extends State<TestFlutterReduxPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller = RefreshController();

  Store<ListState> _getStore() {
    if (context == null) {
      return null;
    }
    return StoreProvider.of<ListState>(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<ListState, ListViewModel>(
      converter: (store) {
        return ListViewModel(
          state: store.state,
        );
      },
      builder: (BuildContext context, ListViewModel vm) {
        return Scaffold(
          appBar: AppBar(title: Text('Flutter redux')),
          body: SmartRefresher(
            controller: _controller,
            child: buildList(vm.state),
            onRefresh: refresh,
            onLoading: loadMore,
            enablePullUp: true,
            header: MaterialClassicHeader(),
          ),
        );
      },
    );
  }

  Widget buildList(ListState state) {
    print("build:${state}");
    if (state is ListPopulatedState) {
      List<Animate> movies = state.result;
      print("buildList:${movies == null ? 0 : movies.length}");
      return ListView.builder(
        itemCount: movies == null ? 0 : movies.length,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            buildItem(context, index, movies),
      );
    } else if (state is ListInitialState) {
      return Center(
        child: Text("init."),
      );
    } else if (state is ListLoadingState) {
      return Center(
        child: Text("loading."),
      );
    } else if (state is ListEmptyState) {
      return GestureDetector(
        onTap: () {
          _getStore().dispatch(ListAction(""));
        },
        child: Center(
          child: Text("no data."),
        ),
      );
    }
  }

  Widget buildItem(BuildContext context, int index, List<Animate> movies) {
    return GestureDetector(
      child: MovieListItem(bean: movies[index]),
      onTap: () {},
    );
  }

  @override
  bool get wantKeepAlive => true;

  void refresh() {
    print("refresh:");
    _getStore().dispatch(ListAction(""));
  }

  void loadMore() {
    print("loadMore:");
    _getStore().dispatch(ListMoreAction(""));
  }
}
