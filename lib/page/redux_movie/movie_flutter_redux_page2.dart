import 'package:AFlutter/action/action.dart';
import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/page/movie_list_item.dart';
import 'package:AFlutter/page/redux_movie/movie_middleware.dart';
import 'package:AFlutter/page/redux_movie/movie_reducer.dart';
import 'package:AFlutter/redux/list_result.dart';
import 'package:AFlutter/redux/list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class MovieFlutterReduxPage2 extends StatefulWidget {
  MovieFlutterReduxPage2({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MovieFlutterReduxPage2State();
  }

  @override
  String toStringShort() {
    return "Redux2";
  }
}

class MovieFlutterReduxPage2State extends State<MovieFlutterReduxPage2>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller;
  final astore = Store<ListState<Animate>>(
    movieReducer,
    middleware: createMoviesMiddleware(),
    initialState: ListState<Animate>(),
  );

  @override
  void initState() {
    super.initState();
    _controller = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreProvider<ListState<Animate>>(
      store: astore,
      child: buildRedux(context),
    );
  }

  Widget buildRedux(BuildContext context) {
    return StoreConnector<ListState<Animate>, _ListViewModel>(
      onInit: (store) {
        store.dispatch(ListAction(""));
      },
      converter: _ListViewModel.fromStore,
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
    ListState<Animate> result = viewModel.state;
    print("build:$result");
    if (result.loadStatus == ListStatus.success) {
      List<Animate> movies = result.list;
      print("buildList:${movies == null ? 0 : movies.length}");
      _controller.refreshCompleted();
      _controller.loadComplete();
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
    _controller.refreshCompleted();
    _controller.loadComplete();
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
  final ListState<Animate> state;
  final Function() refresh;
  final Function() loadMore;

  _ListViewModel({
    @required this.state,
    @required this.refresh,
    @required this.loadMore,
  });

  static _ListViewModel fromStore(Store<ListState> store) {
    return _ListViewModel(
      state: store.state,
      refresh: () {
        print("refresh:${store.state.pageIndex}");
        store.dispatch(ListAction(""));
      },
      loadMore: () {
        print("loadMore:${store.state.pageIndex}");
        store.dispatch(ListMoreAction(""));
      },
    );
  }
}
