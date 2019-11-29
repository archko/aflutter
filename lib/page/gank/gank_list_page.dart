import 'package:AFlutter/entity/gank_bean.dart';
import 'package:AFlutter/model/base_list_view_model.dart';
import 'package:AFlutter/page/gank/gank_detail_page.dart';
import 'package:AFlutter/page/gank/gank_list_image_item.dart';
import 'package:AFlutter/page/gank/gank_list_noimage_item.dart';
import 'package:AFlutter/service/gank_service.dart';
import 'package:AFlutter/widget/list/load_more_status.dart';
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
    await GankService.loadData(type: widget.type, pn: loadModel.page)
        .then((list) {
      loadModel.setData(list.beans);
      setState(() {
        //print("refresh end.${loadModel.page}, ${loadModel.getCount()}");
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
    if (loadModel.getCount() < 1) {
      return refresh();
    }
    setState(() {
      loadMoreStatus = (LoadMoreStatus.LOADING);
    });
    await GankService.loadMore(widget.type, loadModel.page + 1).then((list) {
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
    }).catchError((error) => setState(() {
          print("refresh error:$error");
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
