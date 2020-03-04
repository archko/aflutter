import 'package:AFlutter/model/movie_provider.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:AFlutter/page/movie_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/provider_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MovieProviderPage extends StatefulWidget {
  MovieProviderPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MovieProviderPageState();
  }

  @override
  String toStringShort() {
    return "Provider";
  }
}

class _MovieProviderPageState extends State<MovieProviderPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  RefreshController refreshController;
  MovieProvider _movieProvider;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: true);
    _movieProvider = MovieProvider(
        viewModel: MovieViewModel(), refreshController: refreshController);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MovieProvider>(
      model: _movieProvider,
      onModelInitial: (m) {
        refreshController.requestRefresh();
      },
      builder: (context, model, childWidget) {
        return Container(
          margin: EdgeInsets.all(4),
          child: SmartRefresher(
            physics: BouncingScrollPhysics(),
            enablePullDown: true,
            enablePullUp: true,
            controller: refreshController,
            onRefresh: model.refresh,
            onLoading: model.loadMore,
            header: MaterialClassicHeader(),
            footer: ClassicFooter(),
            child: ListView.builder(
              itemCount: model.viewModel.getCount(),
              itemBuilder: (BuildContext context, int index) =>
                  _renderItem(context, index),
            ),
          ),
        );
      },
    );
  }

  _renderItem(context, index) {
    var item = _movieProvider.viewModel.data[index];
    return GestureDetector(
      onTap: () {},
      child: MovieListItem(bean: item),
    );
  }
}
