import 'package:AFlutter/list/movie_list_page.dart';
import 'package:AFlutter/model/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';

import '../list/movie_list_item.dart';

class TestProviderModePage extends StatefulWidget {
  TestProviderModePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TestProviderModePageState();
  }
}

class TestProviderModePageState extends State<TestProviderModePage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Flutter provider')),
      body: SmartRefresher(
        controller: _controller,
        child: buildList(model.getMovies()),
        enablePullUp: true,
        header: MaterialClassicHeader(),
      ),
    );
  }

  Widget buildList(List<Animate> movies) {
    print("buildList:${movies == null ? 0 : movies.length}");
    return ListView.builder(
      itemCount: movies == null ? 0 : movies.length,
      scrollDirection: Axis.vertical,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) =>
          buildItem(context, index, movies),
    );
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