import 'package:AFlutter/entity/gank_bean.dart';
import 'package:AFlutter/entity/gank_category.dart';
import 'package:AFlutter/model/provider/gank_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/provider_widget.dart';

import 'gank_detail_page.dart';
import 'gank_list_image_item.dart';
import 'gank_list_noimage_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GankListPage extends StatefulWidget {
  GankListPage({Key key, this.category, this.category_type}) : super(key: key);
  final GankCategory category;
  final String category_type;

  @override
  _GankListPageState createState() => new _GankListPageState();

  @override
  String toStringShort() {
    return category.title;
  }
}

class _GankListPageState extends State<GankListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController;
  GankProvider _gankProvider;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    _gankProvider = GankProvider(
      category: widget.category_type,
      type: widget.category.type,
      refreshController: _refreshController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProviderWidget<GankProvider>(
        model: _gankProvider,
        onModelInitial: (m) {
          _gankProvider.refresh();
        },
        builder: (context, model, childWidget) {
          return Container(
            margin: EdgeInsets.only(top: 10, bottom: 5),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController,
              onRefresh: model.refresh,
              onLoading: model.loadMoreGank,
              header: MaterialClassicHeader(),
              //onLoading: model.loadMore,
              child: ListView.builder(
                itemCount: model.getCount(),
                itemBuilder: (BuildContext context, int index) =>
                    _renderItem(context, index, model.getCount()),
              ),
            ),
          );
        },
      ),
    );
    //return PullToRefreshWidget(
    //  itemBuilder: (BuildContext context, int index) =>
    //      _renderItem(index, context),
    //  listCount: loadModel.getCount() + 1,
    //  onLoadMore: loadMore,
    //  onRefresh: refresh,
    //  loadMoreStatus: loadMoreStatus,
    //);
  }

  void detail(GankBean bean) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new GankDetailPage(
            bean: bean,
          );
        },
      ),
    );
  }

  //列表的ltem
  _renderItem(context, index, int count) {
    GankBean bean = _gankProvider.getData()[index];
    if (bean.images == null || bean.images.length < 1) {
      return GankListNoImageItem(
          bean: bean,
          onPressed: () {
            detail(bean);
          });
    } else {
      return GankListImageItem(
          bean: bean,
          onPressed: () {
            detail(bean);
          });
    }
  }
}
