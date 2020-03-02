import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/list_view_model.dart';
import 'package:AFlutter/page/movie_list_item.dart';
import 'package:AFlutter/redux/app_redux.dart';
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
}

class MovieFlutterReduxPageState extends State<MovieFlutterReduxPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller = RefreshController();

  Store<ListState<Animate>> _getStore() {
    if (context == null) {
      return null;
    }
    return StoreProvider.of<ListState<Animate>>(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<ListState<Animate>, ListViewModel>(
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

  Widget buildList(ListState<Animate> state) {
    print("build:$state");
    if (state is ListPopulatedState) {
      List<Animate> movies = state.data;
      print("buildList:${movies == null ? 0 : movies.length}");
      _controller.refreshCompleted(resetFooterState: true);
      return ListView.builder(
        itemCount: movies == null ? 0 : movies.length,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
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
    } else if (state is ListErrorState) {
      _controller?.loadFailed();
    } else if (state is ListEmptyState) {
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
