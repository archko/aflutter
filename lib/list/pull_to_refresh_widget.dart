import 'package:AFlutter/state/load_model.dart';
import 'package:flutter/material.dart';

class PullToRefreshWidget extends StatefulWidget {
  PullToRefreshWidget(
      {Key key,
      this.loadModel,
      this.itemBuilder,
      this.onLoadMore,
      this.onRefresh})
      : super(key: key);
  final LoadModel loadModel;
  final IndexedWidgetBuilder itemBuilder;
  final RefreshCallback onLoadMore;
  final RefreshCallback onRefresh;

  @override
  _PullToRefreshWidgetState createState() => new _PullToRefreshWidgetState();
}

class _PullToRefreshWidgetState extends State<PullToRefreshWidget> {
  ScrollController _scrollController;

  _PullToRefreshWidgetState() : super();

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();

    ///增加滑动监听
    _scrollController.addListener(() {
      ///判断当前滑动位置是不是到达底部，触发加载更多回调
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //if (widget.pullController.needLoadMore.value) {
        _onLoading();
        //}
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> _onRefresh() async {
    widget.onRefresh?.call();
  }

  Future<Null> _onLoading() async {
    widget.onLoadMore?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
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
    return widget.loadModel.dataList.length;
  }

  _getItem(int index) {
    return widget.itemBuilder(context, index);
  }
}
