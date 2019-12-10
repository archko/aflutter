import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/**
 * 参考了gsy的下拉刷新
 */
class PullWidget extends StatefulWidget {
  PullWidget(
      {Key key,
      this.pullController,
      this.itemBuilder,
      this.child,
      this.listCount,
      this.onLoadMore,
      this.onRefresh,
      this.header,
      this.footer})
      : super(key: key);
  final int listCount;
  final RefreshController pullController;
  final IndexedWidgetBuilder itemBuilder;
  final Widget child;
  final RefreshCallback onLoadMore;
  final RefreshCallback onRefresh;
  final Widget header;
  final Widget footer;

  @override
  _PullWidgetState createState() => new _PullWidgetState();
}

class _PullWidgetState extends State<PullWidget> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController;

  _PullWidgetState() : super();

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();

    ///增加滑动监听
    _scrollController.addListener(() {
      ///判断当前滑动位置是不是到达底部，触发加载更多回调
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.onLoadMore?.call();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  Future _onRefresh() async {
    widget.onRefresh?.call();
  }

  Future _onLoading() async {
    widget.onLoadMore?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: widget.header != null ? widget.header : MaterialClassicHeader(),
        footer: widget.footer != null
            ? widget.footer
            : CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CircularProgressIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
        controller: widget.pullController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: widget.child != null
            ? widget.child
            : new ListView.builder(
                ///保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题。
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _getItem(index);
                },

                itemCount: _getListCount(),
                controller: _scrollController,
              ),
      ),
    );
  }

  int _getListCount() {
    return widget.listCount;
  }

  _getItem(int index) {
    return widget.itemBuilder(context, index);
  }
}
