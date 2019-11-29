import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListMoreWidget extends StatelessWidget {
  ListMoreWidget({Key key, this.loadMoreStatus, this.retry}) : super(key: key);

  LoadMoreStatus loadMoreStatus;
  final Function retry;

  @override
  Widget build(BuildContext context) {
    print("build:$loadMoreStatus");
    Widget widget;
    if (loadMoreStatus == LoadMoreStatus.FAIL) {
      if (retry != null) {
        widget = Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 30),
          child: Text("load failed."),
        );
        widget = GestureDetector(
          onTap: () {
            retry();
          },
          child: widget,
        );
      }
    } else if (loadMoreStatus == LoadMoreStatus.IDLE) {
      widget = Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 30),
        child: Text("load more."),
      );
    } else if (loadMoreStatus == LoadMoreStatus.NOMORE) {
      widget = Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 30),
        child: Text("no more."),
      );
    } else if (loadMoreStatus == LoadMoreStatus.LOADING) {
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 5.0),
            height: 15.0,
            width: 15.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 30),
            child: Text("loading..."),
          ),
        ],
      );
    } else {
      widget = Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 30),
        child: Text("nothing."),
      );
    }
    return widget;
  }
}

enum LoadMoreStatus {
  /// 空闲中，表示当前等待加载
  ///
  /// wait for loading
  IDLE,

  /// 刷新中，不应该继续加载，等待future返回
  ///
  /// the view is loading
  LOADING,

  /// 刷新失败，刷新失败，这时需要点击才能刷新
  ///
  /// loading fail, need tap view to loading
  FAIL,

  /// 没有更多，没有更多数据了，这个状态不触发任何条件
  ///
  /// not have more data
  NOMORE,
  //no item
  EMPTY,
}
