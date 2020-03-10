import 'package:AFlutter/redux/list_result.dart';

/// load Actions
class ListAction {
  final String term;

  ListAction(this.term);
}

class ListMoreAction {
  final String term;

  ListMoreAction(this.term);
}

class ListResultAction<T> {
  final List<T> result;
  final ListStatus status;
  final String msg;

  ListResultAction(this.result, this.status, this.msg);
}

class ListMoreResultAction<T> {
  final List<T> result;
  final ListStatus status;
  final String msg;

  ListMoreResultAction(this.result, this.status, this.msg);
}
