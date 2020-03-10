import 'package:AFlutter/redux/list_result.dart';

abstract class Cloneable<T extends Cloneable<T>> {
  T clone();
}

class ListState<R> implements Cloneable<ListState<R>> {
  List<R> list;
  int pageIndex;
  ListStatus loadStatus;

  ListState({
    this.list,
    this.pageIndex = 0,
    this.loadStatus = ListStatus.initial,
  }) {
    if (null == list) {
      list = [];
    }
  }

  @override
  ListState<R> clone() {
    return ListState()
      ..pageIndex = pageIndex
      ..list = list;
  }

  @override
  String toString() {
    return 'ListState{pageIndex: $pageIndex, loadStatus: $loadStatus, list: $list,}';
  }
}
