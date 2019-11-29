import 'package:AFlutter/entity/gank_bean.dart';
import 'package:AFlutter/model/gank_view_model.dart';
import 'package:AFlutter/page/base_list_state.dart';
import 'package:AFlutter/page/gank/gank_detail_page.dart';
import 'package:AFlutter/page/gank/gank_list_image_item.dart';
import 'package:AFlutter/page/gank/gank_list_noimage_item.dart';
import 'package:AFlutter/widget/list/list_more_widget.dart';
import 'package:AFlutter/widget/list/pull_to_refresh_widget.dart';
import 'package:flutter/material.dart';

class GankListPage extends StatefulWidget {
  GankListPage({Key key, this.title, this.type}) : super(key: key);
  final String title;
  final String type;

  @override
  _GankListPageState createState() => new _GankListPageState();

  @override
  String toStringShort() {
    return type == null ? super.toStringShort() : type;
  }
}

class _GankListPageState extends State<GankListPage>
    with BaseListState<GankListPage>, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var loadMoreStatus = LoadMoreStatus.IDLE;

  @override
  void initState() {
    super.initState();
    viewModel = GankViewModel(page: 1);
    startPage = 1;
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.getCount() < 1 && loadMoreStatus == LoadMoreStatus.IDLE) {
      refresh();
    }
    return PullToRefreshWidget(
      itemBuilder: (BuildContext context, int index) =>
          _renderItem(index, context),
      listCount: viewModel.getCount() + 1,
      onLoadMore: loadMore,
      onRefresh: refresh,
      loadMoreStatus: loadMoreStatus,
    );
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
  _renderItem(index, context) {
    if (index == viewModel.getCount()) {
      return ListMoreWidget(
        loadMoreStatus: loadMoreStatus,
        retry: retry,
      );
    }
    var bean = viewModel.data[index];
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

  Future refresh() async {
    loadMoreStatus = (LoadMoreStatus.LOADING);
    viewModel.setPage(startPage);
    await (viewModel as GankViewModel)
        .loadData(viewModel.page, type: widget.type)
        .then((list) {
      viewModel.setData(list.beans);
      setState(() {
        //print("refresh end.${viewModel.page}, ${viewModel.getCount()}");
        if (list.beans.length < 1) {
          loadMoreStatus = (LoadMoreStatus.NOMORE);
        } else {
          loadMoreStatus = (LoadMoreStatus.IDLE);
        }
      });
    }).catchError((error) => setState(() {
              print("refresh error:$error");
              loadMoreStatus = (LoadMoreStatus.FAIL);
            }));
  }

  Future<void> loadMore() async {
    if (viewModel.getCount() < 1) {
      return refresh();
    }
    setState(() {
      loadMoreStatus = (LoadMoreStatus.LOADING);
    });
    await (viewModel as GankViewModel)
        .loadMore(viewModel.page + 1, type: widget.type)
        .then((list) {
      viewModel.updateDataAndPage(list.beans, viewModel.page + 1);
      setState(() {
        if (list.beans.length < 1) {
          loadMoreStatus = (LoadMoreStatus.NOMORE);
        } else {
          loadMoreStatus = (LoadMoreStatus.IDLE);
        }
        print(
            "loadMore end.$loadMoreStatus,${viewModel.page}, ${viewModel.getCount()}");
      });
    }).catchError((error) => setState(() {
              print("refresh error:$error");
              loadMoreStatus = (LoadMoreStatus.FAIL);
            }));
  }
}
