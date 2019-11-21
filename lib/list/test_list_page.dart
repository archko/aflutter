import 'package:AFlutter/list/pull_widget.dart';
import 'package:AFlutter/list/test_list_item.dart';
import 'package:flutter/material.dart';

class TestListPage extends StatefulWidget {
  TestListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TestListPageState createState() => new _TestListPageState();
}

class _TestListPageState extends State<TestListPage>
    with AutomaticKeepAliveClientMixin {
  List items = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
  ];

  PullWidgetController _pullController = new PullWidgetController();

  @override
  void initState() {
    super.initState();
    _pullController.dataList = items;
  }

  @override
  bool get wantKeepAlive => true;
  int page = 1;
  bool isLoading = false;
  bool isRefreshing = false;
  bool isLoadMoring = false;

  _lockToAwait() async {
    ///if loading, lock to await
    doDelayed() async {
      await Future.delayed(Duration(seconds: 1)).then((_) async {
        if (isLoading) {
          return await doDelayed();
        } else {
          return null;
        }
      });
    }

    await doDelayed();
  }

  @protected
  Future<Null> handleRefresh() async {
    if (isLoading) {
      if (isRefreshing) {
        return null;
      }
      await _lockToAwait();
    }
    isLoading = true;
    isRefreshing = true;
    page = 1;
    var res = await requestRefresh();
    print("res:$res;");
    if (res != null) {
      resolveRefreshResult(res);
      setState(() {
        _pullController.needRefresh.value =  true;
      });
    }
    isLoading = false;
    isRefreshing = false;
    return null;
  }

  @protected
  resolveRefreshResult(res) {
    if (res != null) {
      _pullController?.dataList?.clear();
      setState(() {
        _pullController?.dataList?.addAll(res);
        //print("resolveRefreshResult:$res;");
      });
    }
  }

  @protected
  Future<Null> onLoadMore() async {
    if (isLoading) {
      if (isLoadMoring) {
        return null;
      }
      await _lockToAwait();
    }
    isLoading = true;
    isLoadMoring = true;
    page++;
    var res = await requestLoadMore();
    if (res != null) {
      setState(() {
        _pullController?.dataList?.addAll(res);
      });
    }
    setState(() {
      _pullController.needLoadMore.value = (res != null);
    });
    isLoading = false;
    isLoadMoring = false;
    return null;
  }

  //下拉刷新数据
  @protected
  requestRefresh() async {
    return [
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
    ];
  }

  ///上拉更多请求数据
  @protected
  requestLoadMore() async {
    return [(_pullController.dataList.length + 1).toString()];
  }

  _renderItem(int index) {
    if (_pullController.dataList.length == 0) {
      return null;
    }
    //print("item:${_pullController.dataList[index]}");
    switch (index) {
      case 2:
        return new TestListItem(bean: _pullController.dataList[index], onPressed: () {});
      default:
        return new TestListItem(bean: _pullController.dataList[index], onPressed: () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new PullWidget(
      pullController: _pullController,
      items: _pullController.dataList,
      itemBuilder: (BuildContext context, int index) => _renderItem(index),
      onLoadMore: onLoadMore,
      onRefresh: handleRefresh,
    );
  }
}
