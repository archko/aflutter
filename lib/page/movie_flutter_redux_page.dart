import 'package:AFlutter/action/action.dart';
import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/page/movie_list_item.dart';
import 'package:AFlutter/redux/app_redux.dart';
import 'package:AFlutter/redux/list_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class MovieFlutterReduxPage extends StatefulWidget {
  MovieFlutterReduxPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MovieFlutterReduxPageState();
  }

  @override
  String toStringShort() {
    return "Redux";
  }
}

class MovieFlutterReduxPageState extends State<MovieFlutterReduxPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller;

  Store<AppState> _getStore() {
    if (context == null) {
      return null;
    }
    return StoreProvider.of<AppState>(context);
  }

  @override
  void initState() {
    super.initState();
    _controller = RefreshController(initialRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ListViewModel>(
      onInit: (state) {
        state.dispatch(ListAction(""));
      },
      converter: (store) {
        return _ListViewModel(
          state: store.state.movies,
        );
      },
      builder: (BuildContext context, _ListViewModel vm) {
        return Scaffold(
          //appBar: AppBar(title: Text('Flutter redux')),
          body: SmartRefresher(
            physics: BouncingScrollPhysics(),
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

  Widget buildList(ListResult<Animate> result) {
    print("build:$result");
    if (result.loadStatus == ListStatus.success) {
      List<Animate> movies = result.data;
      print("buildList:${movies == null ? 0 : movies.length}");
      _controller.refreshCompleted(resetFooterState: true);
      return ListView.builder(
        itemCount: movies == null ? 0 : movies.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) =>
            buildItem(context, index, movies),
      );
    } else if (result.loadStatus == ListStatus.initial) {
      return Center(
        child: Text("init."),
      );
    } else if (result.loadStatus == ListStatus.loading) {
      return Center(
        child: Text("loading."),
      );
    } else if (result.loadStatus == ListStatus.error) {
      _controller?.loadFailed();
    } else if (result.loadStatus == ListStatus.empty) {
      _controller?.resetNoData();
      return GestureDetector(
        onTap: () {
          _getStore().dispatch(ListAction(""));
        },
        child: Center(
          child: Text("no data."),
        ),
      );
    }
    _controller.refreshCompleted(resetFooterState: true);
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

class _ListViewModel {
  final ListResult<Animate> state;

  _ListViewModel({
    this.state,
  });
}
