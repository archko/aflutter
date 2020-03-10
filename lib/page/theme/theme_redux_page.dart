import 'package:AFlutter/redux/theme_reducer.dart';
import 'package:AFlutter/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:AFlutter/model/movie_provider.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:AFlutter/page/movie_list_item.dart';
import 'package:flutter_base/model/provider_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ThemeReduxPage extends StatefulWidget {
  ThemeReduxPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ThemeReduxPageState();
  }

  @override
  String toStringShort() {
    return "Theme";
  }
}

class ThemeReduxPageState extends State<ThemeReduxPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: true);
    _movieProvider = MovieProvider(
        viewModel: MovieViewModel(), refreshController: refreshController);
  }

  List<MaterialColor> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.cyan,
    Colors.purple
  ];
  int index = 0;
  RefreshController refreshController;
  MovieProvider _movieProvider;

  @override
  void didUpdateWidget(ThemeReduxPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget:$this");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies:$this");
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MovieProvider>(
      model: _movieProvider,
      onModelInitial: (m) {
        refreshController.requestRefresh();
      },
      builder: (context, model, childWidget) {
        return SmartRefresher(
          physics: BouncingScrollPhysics(),
          enablePullDown: true,
          enablePullUp: true,
          controller: refreshController,
          onRefresh: model.refresh,
          onLoading: model.loadMore,
          header: MaterialClassicHeader(),
          footer: ClassicFooter(),
          //child: ListView.builder(
          //  itemCount: model.viewModel.getCount(),
          //  itemBuilder: (BuildContext context, int index) =>
          //      _renderItem(context, index),
          //),
          child: buildContent(context, model),
        );
      },
    );
  }

  Widget buildHeader(BuildContext context) {
    return StoreConnector<AppState, ThemeModel>(
      converter: (store) {
        return ThemeModel(store.state.themeData);
      },
      builder: (BuildContext context, ThemeModel vm) {
        return Center(
          child: RaisedButton(
            onPressed: () {
              changeTheme();
            },
            child: Text("change theme"),
          ),
        );
      },
    );
  }

  Widget buildContent(BuildContext context, MovieProvider provider) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: buildHeader(context),
        ),

        /// 相关视频列表
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return MovieListItem(bean: provider.viewModel.data[index]);
            },
            childCount: provider.viewModel.getCount(),
          ),
        ),
      ],
    );
  }

  void changeTheme() {
    if (index >= colors.length) {
      index = 0;
    }
    StoreProvider.of<AppState>(context).dispatch(RefreshThemeDataAction(
        ThemeData(
            primarySwatch: colors[index++], platform: TargetPlatform.android)));
  }
}

class ThemeModel {
  ThemeData themeData;

  ThemeModel(this.themeData);
}
