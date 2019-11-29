import 'package:AFlutter/model/base_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

mixin BaseListState<T extends StatefulWidget> on State<T> {
  BaseListViewModel viewModel;
  RefreshController refreshController;
  int startPage = 0;

  @override
  void dispose() {
    super.dispose();
    refreshController.dispose();
  }

  Future refresh() async {
    viewModel.setPage(startPage);
    await viewModel.loadData(viewModel.page).then((list) {
      viewModel.setData(list);
      setState(() {
        print("refresh end.${viewModel.page}, ${viewModel.getCount()}");
        if (list.length < 1) {
          refreshController.loadNoData();
        } else {
          refreshController.refreshCompleted(resetFooterState: true);
        }
      });
    }).catchError((_) => setState(() {
          print("refresh error");
          refreshController.loadFailed();
        }));
  }

  Future<void> loadMore() async {
    if (viewModel.getCount() < 1) {
      return refresh();
    }

    await viewModel.loadMore(viewModel.page + 1).then((list) {
      viewModel.updateDataAndPage(list, viewModel.page + 1);
      setState(() {
        if (list.length < 1) {
          refreshController.loadNoData();
        } else {
          refreshController.refreshCompleted(resetFooterState: true);
        }
        print(
            "loadMore end.${refreshController.footerStatus},${viewModel.page}, ${viewModel.getCount()}");
      });
    }).catchError((_) => setState(() {
          refreshController.loadFailed();
        }));
  }

  retry() {
    if (viewModel.getCount() < 1) {
      refresh();
    } else {
      loadMore();
    }
  }
}
