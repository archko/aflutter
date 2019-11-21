import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PullWidget extends StatefulWidget {
  PullWidget(
      {Key key,
      this.pullController,
      this.items,
      this.itemBuilder,
      this.onLoadMore,
      this.onRefresh})
      : super(key: key);
  final List items;
  final PullWidgetController pullController;
  final IndexedWidgetBuilder itemBuilder;
  final RefreshCallback onLoadMore;
  final RefreshCallback onRefresh;

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
    widget.pullController.needLoadMore?.addListener(() {
      _refreshController.loadComplete();
    });
    widget.pullController.needRefresh?.addListener(() {
      _refreshController.refreshCompleted();
    });

    ///增加滑动监听
    _scrollController.addListener(() {
      ///判断当前滑动位置是不是到达底部，触发加载更多回调
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (widget.pullController.needLoadMore.value) {
          widget.onLoadMore?.call();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  void _onRefresh() async {
    // monitor network fetch
    /*await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();*/
    widget.pullController.needRefresh.value = false;
    widget.onRefresh?.call();
  }

  void _onLoading() async {
    // monitor network fetch
    /*await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    widget.items.add((widget.items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();*/
    widget.pullController.needLoadMore.value = false;
    widget.onLoadMore?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
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
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: new ListView.builder(
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
    return widget.items.length;
  }

  _getItem(int index) {
    return widget.itemBuilder(context, index);
    //return Card(child: Center(child: Text(items[index])));
  }
}

class PullWidgetController {
  List dataList = new List();

  ValueNotifier<bool> needLoadMore = new ValueNotifier(false);
  ValueNotifier<bool> needRefresh = new ValueNotifier(false);
}
