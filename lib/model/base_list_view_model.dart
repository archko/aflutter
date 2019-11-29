abstract class BaseListViewModel<T> {
  bool hasMore = true;
  bool isRefreshing = false;
  int page = 0;
  List<T> data = new List<T>();

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

  List<T> getData() {
    return data;
  }

  void addData(List<T> list) {
    if (null != list) {
      data.addAll(list);
    }
  }

  void updateDataAndPage(List<T> list, int pageNumber) {
    if (null != list) {
      data.addAll(list);
    }
    page = pageNumber;
  }

  void setData(List<T> list) {
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

  Future loadData(int pn);

  Future loadMore(int pn);
}
