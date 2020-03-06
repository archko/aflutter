enum ListStatus { initial, loading, nomore, error, success, empty }

class ListResult<T> {
  List<T> data = [];
  ListStatus loadStatus;
  String msg;

  ListResult(this.data, this.loadStatus, this.msg);

  @override
  String toString() {
    return 'ListResult{loadStatus: $loadStatus, msg: $msg, data: $data}';
  }
}
