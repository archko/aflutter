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
        return _ListViewModel.fromStore(store);
      },
      builder: (BuildContext context, _ListViewModel vm) {
        return Scaffold(
          //appBar: AppBar(title: Text('Flutter redux')),
          body: SmartRefresher(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            child: buildList(vm),
            onRefresh: vm.refresh,
            onLoading: vm.loadMore,
            enablePullUp: true,
            header: MaterialClassicHeader(),
          ),
        );
      },
    );
  }

  Widget buildList(_ListViewModel viewModel) {
    ListResult<Animate> result = viewModel.result;
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
          viewModel.refresh();
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
}

class _ListViewModel {
  final ListResult<Animate> result;
  final Function() refresh;
  final Function() loadMore;

  _ListViewModel({
    this.result,
    this.refresh,
    this.loadMore,
  });

  static _ListViewModel fromStore(Store<AppState> store) {
    return _ListViewModel(
      result: store.state.movies,
      refresh: () {
        print("refresh:");
        store.dispatch(ListAction(""));
      },
      loadMore: () {
        print("loadMore:");
        store.dispatch(ListMoreAction(""));
      },
    );
  }
}
