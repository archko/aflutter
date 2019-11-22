import 'package:AFlutter/list/movie_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

import '../list/movie_list_item.dart';
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

  Store<SearchState> _getStore() {
    if (context == null) {
      return null;
    }
    return StoreProvider.of<SearchState>(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getStore().dispatch(SearchAction(""));
    return StoreConnector<SearchState, _SearchScreenViewModel>(
      converter: (store) {
        return _SearchScreenViewModel(
          state: store.state,
        );
      },
      builder: (BuildContext context, _SearchScreenViewModel vm) {
        return Scaffold(
          appBar: AppBar(title: Text('Flutter redux')),
          body: SmartRefresher(
            controller: _controller,
            child: buildList(vm.state),
            enablePullUp: true,
            header: MaterialClassicHeader(),
          ),
        );
      },
    );
  }

  Widget buildList(SearchState state) {
    print("build:${state}");
    if (state is SearchPopulated) {
      List<Animate> movies = state.result;
      print("buildList:${movies == null ? 0 : movies.length}");
      return ListView.builder(
        itemCount: movies == null ? 0 : movies.length,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            buildItem(context, index, movies),
      );
    } else if (state is SearchInitial) {
      return Center(
        child: Text("init."),
      );
    } else if (state is SearchLoading) {
      return Center(
        child: Text("loading."),
      );
    } else if (state is SearchEmpty) {
      return Center(
        child: Text("no data."),
      );
    }
  }

  Widget buildItem(BuildContext context, int index, List<Animate> movies) {
    print("item:$index");
    return GestureDetector(
      child: MovieListItem(bean: movies[index]),
      onTap: () {},
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SearchScreenViewModel {
  final SearchState state;

  _SearchScreenViewModel({
    this.state,
  });
}
