import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:AFlutter/model/provider_widget.dart';
import 'package:AFlutter/model/test_provider.dart';
import 'package:AFlutter/page/movie/movie_list_item.dart';
import 'package:AFlutter/widget/list/pull_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SecondProviderPage extends StatefulWidget {
  SecondProviderPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SecondProviderPageState();
  }
}

class SecondProviderPageState extends State<SecondProviderPage> {
  RefreshController _controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return build3(context);
  }

  Widget build1(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test provider"),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              builder: (_) => TestProvider(
                  refreshController: _controller, viewModel: MovieViewModel())),
        ],
        child: Consumer<TestProvider>(
          builder: (context, model, _) {
            return SmartRefresher(
              controller: _controller,
              onRefresh: model.refresh,
              onLoading: model.loadMore,
              child: buildList(model.getMovies()),
              enablePullUp: true,
              header: MaterialClassicHeader(),
            );
          },
        ),
      ),
    );
  }

  Widget build2(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test provider"),
      ),
      body: ProviderWidget<TestProvider>(
        model: TestProvider(
            viewModel: MovieViewModel(), refreshController: _controller),
        onModelInitial: (m) {
          m.refresh();
        },
        builder: (context, model, child) {
          return Container(
            color: Color(0xFFF4F4F4),
            child: RefreshConfiguration(
              enableLoadingWhenNoData: false,
              child: PullWidget(
                header: WaterDropHeader(),
                pullController: _controller,
                onRefresh: model.refresh,
                onLoadMore: model.loadMore,
                child: buildList(model.getMovies()),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget build3(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test provider"),
      ),
      body: ProviderWidget<TestProvider>(
        model: TestProvider(
            viewModel: MovieViewModel(), refreshController: _controller),
        onModelInitial: (m) {
          m.refresh();
        },
        builder: (context, model, child) {
          return SmartRefresher(
            controller: _controller,
            onRefresh: model.refresh,
            onLoading: model.loadMore,
            child: buildList(model.getMovies()),
            enablePullUp: true,
            header: MaterialClassicHeader(),
          );
        },
      ),
    );
  }

  Future refresh() async {}

  Future<void> loadMore() async {}

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
}
