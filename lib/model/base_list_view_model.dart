class BaseListViewModel {
  bool hasMore = true;
  bool isRefreshing = false;
  int page = 0;
  List dataList = new List();

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

  List getDataList() {
    return dataList;
  }

  addDataList(List list) {
    dataList.addAll(list);
  }

  setDataList(List list) {
    dataList = list;
  }

  @override
  String toString() {
    return "hasMore:$hasMore,"
        "isRefreshing:$isRefreshing,"
        "page:$page,"
        "data:${dataList.toString()}";
  }
}
