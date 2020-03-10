import 'package:AFlutter/action/action.dart';
import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:AFlutter/page/list_state.dart';
import 'package:AFlutter/page/movie_list_item.dart';
import 'package:AFlutter/redux/list_result.dart';
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

/// Reducer
final movieReducer = combineReducers<ListState<Animate>>([
  TypedReducer<ListState<Animate>, ListResultAction<Animate>>(_onResult),
  TypedReducer<ListState<Animate>, ListMoreResultAction<Animate>>(
      _onMoreResult),
]);

ListState<Animate> _onResult(ListState state, ListResultAction action) =>
    state.clone()
      ..list = action.result
      ..pageIndex = state.pageIndex
      ..loadStatus = action.status;

ListState<Animate> _onMoreResult(
        ListState state, ListMoreResultAction action) =>
    state.clone()
      ..list.addAll(action.result)
      ..pageIndex = state.pageIndex + 1
      ..loadStatus = action.status;

class MovieFlutterReduxPage2State extends State<MovieFlutterReduxPage2>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller;
  final astore = Store<ListState<Animate>>(
    movieReducer,
    middleware: createAStoreMoviesMiddleware(),
    initialState: ListState(),
  );

  @override
  void initState() {
    super.initState();
    _controller = RefreshController(initialRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreProvider<ListState<Animate>>(
      store: astore,
      child: StoreBuilder<ListState<Animate>>(
        builder: (context, store) {
          return MaterialApp(
            home: buildRedux(context),
          );
        },
      ),
    );
  }

  Widget buildRedux(BuildContext context) {
    return StoreConnector<ListState<Animate>, _ListViewModel>(
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
    ListState<Animate> result = viewModel.result;
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
  final ListState<Animate> result;
  final Function() refresh;
  final Function() loadMore;

  _ListViewModel({
    @required this.result,
    @required this.refresh,
    @required this.loadMore,
  });

  static _ListViewModel fromStore(Store<ListState> store) {
    return _ListViewModel(
      result: store.state,
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

List<Middleware<ListState>> createAStoreMoviesMiddleware() {
  final loadMovies = _createLoadMovies();
  final refreshMovies = _createLoadMovies();
  final loadMoreMovies = _createLoadMoreMovies();

  return [
    TypedMiddleware<ListState, ListAction>(loadMovies),
    //TypedMiddleware<ListState, ListAction>(refreshMovies),
    TypedMiddleware<ListState, ListMoreAction>(loadMoreMovies),
  ];
}

Middleware<ListState> _createLoadMovies() {
  return (Store<ListState> store, action, NextDispatcher next) {
    MovieViewModel().loadData(store.state.pageIndex).then(
      (movies) {
        if (movies != null) {
          store.dispatch(
            ListResultAction(movies, ListStatus.success, null),
          );
        } else {
          store.dispatch(
            ListResultAction(movies, ListStatus.empty, null),
          );
        }
      },
    ).catchError((e) => store.dispatch(
          ListResultAction(null, ListStatus.error, e.toString()),
        ));

    next(action);
  };
}

Middleware<ListState> _createLoadMoreMovies() {
  return (Store<ListState> store, action, NextDispatcher next) {
    MovieViewModel().loadMore(store.state.pageIndex + 1).then(
      (movies) {
        if (movies != null) {
          store.dispatch(
            ListMoreResultAction(movies, ListStatus.success, null),
          );
        } else {
          store.dispatch(
            ListMoreResultAction(movies, ListStatus.nomore, null),
          );
        }
      },
    ).catchError((e) => store.dispatch(
          ListMoreResultAction(null, ListStatus.error, e.toString()),
        ));

    next(action);
  };
}
