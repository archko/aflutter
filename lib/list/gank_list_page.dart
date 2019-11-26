import 'package:AFlutter/model/base_list_view_model.dart';
import 'package:AFlutter/service/GankService.dart';
import 'package:AFlutter/state/load_more_status.dart';
import 'package:AFlutter/widget/list_more_widget.dart';
import 'package:flutter/material.dart';

import '../entity/gank_bean.dart';
import '../entity/gank_today.dart';
import 'gank_detail_page.dart';
import 'gank_list_image_item.dart';
import 'gank_list_noimage_item.dart';
import 'pull_to_refresh_widget.dart';

class GankListPage extends StatefulWidget {
  GankListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GankListPageState createState() => new _GankListPageState();
}

class _GankListPageState extends State<GankListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  BaseListViewModel loadModel = BaseListViewModel(page: 1);
  var loadMoreStatus = LoadMoreStatus.IDLE;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loadModel.getCount() < 1 && loadMoreStatus == LoadMoreStatus.IDLE) {
      refresh();
    }
    return PullToRefreshWidget(
      itemBuilder: (BuildContext context, int index) =>
          _renderItem(index, context),
      listCount: loadModel.getCount() + 1,
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
    if (index == loadModel.getCount()) {
      return ListMoreWidget(
        loadMoreStatus: loadMoreStatus,
        retry: retry,
      );
    }
    var bean = loadModel.data[index];
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
    loadModel.setPage(1);
    await GankService.loadData(pn:loadModel.page).then((list) {
      loadModel.setData(list.beans);
      setState(() {
        print("refresh end.${loadModel.page}, ${loadModel.getCount()}");
        if (list.beans.length < 1) {
          loadMoreStatus = (LoadMoreStatus.NOMORE);
        } else {
          loadMoreStatus = (LoadMoreStatus.IDLE);
        }
      });
    }).catchError((_) => setState(() {
          print("refresh error");
          loadMoreStatus = (LoadMoreStatus.FAIL);
        }));
  }

  Future<void> loadMore() async {
    if (loadModel.getCount() < 1) {
      return refresh();
    }
    setState(() {
      loadMoreStatus = (LoadMoreStatus.LOADING);
    });
    await GankService.loadMore(loadModel.page + 1).then((list) {
      loadModel.updateDataAndPage(list.beans, loadModel.page + 1);
      setState(() {
        if (list.beans.length < 1) {
          loadMoreStatus = (LoadMoreStatus.NOMORE);
        } else {
          loadMoreStatus = (LoadMoreStatus.IDLE);
        }
        print(
            "loadMore end.$loadMoreStatus,${loadModel.page}, ${loadModel.getCount()}");
      });
    }).catchError((_) => setState(() {
          loadMoreStatus = (LoadMoreStatus.FAIL);
        }));
  }

  retry() {
    if (loadModel.getCount() < 1) {
      refresh();
    } else {
      loadMore();
    }
  }
}
