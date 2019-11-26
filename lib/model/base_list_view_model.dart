class BaseListViewModel {
  bool hasMore = true;
  bool isRefreshing = false;
  int page = 0;
  List data = new List();

  BaseListViewModel({this.page});

  bool get value => hasMore;

  void setHasMore(bool hasMore) {
    this.hasMore = hasMore;
  }

  bool get isRefresh {
    return isRefreshing;
  }

  void setRefresh(bool refreshing) {
    isRefreshing = refreshing;
  }

  void setPage(int page) {
    this.page = page;
  }

  List getData() {
    return data;
  }

  void addData(List list) {
    if (null != list) {
      data.addAll(list);
    }
  }

  void updateDataAndPage(List list, int pageNumber) {
    if (null != list) {
      data.addAll(list);
    }
    page = pageNumber;
  }

  void setData(List list) {
    data = list;
    data ??= [];
  }

  int getCount() {
    return data == null ? 0 : data.length;
  }

  @override
  String toString() {
    return "hasMore:$hasMore,"
        "isRefreshing:$isRefreshing,"
        "page:$page,"
        "data:${data.toString()}";
  }
}
