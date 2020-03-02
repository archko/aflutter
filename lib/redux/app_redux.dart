import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:redux/redux.dart';

abstract class ListState<T> {
  List<T> data = [];
}

class ListInitialState<T> extends ListState<T> {}

class ListLoadingState<T> extends ListState<T> {}

class ListEmptyState<T> extends ListState<T> {}

class ListNoMoreState<T> extends ListState<T> {}

class ListErrorState<T> extends ListState<T> {
  dynamic e;

  ListErrorState(this.e) {
    print("error:$e");
  }
}

class ListPopulatedState<T> extends ListState<T> {
  bool isrefresh;

  ListPopulatedState(result, this.isrefresh) {
    data = result;
    print("reset:$isrefresh.count:${result.length}");
  }
}

/// Actions
class ListAction {
  final String term;

  ListAction(this.term);
}

class ListMoreAction {
  final String term;

  ListMoreAction(this.term);
}

//================================

class ListLoadingAction {}

class ListErrorAction {
  dynamic e;

  ListErrorAction(this.e);
}

class ListResultAction<T> {
  final List<T> result;

  ListResultAction(this.result);
}

class ListMoreResultAction<T> {
  final List<T> result;

  ListMoreResultAction(this.result);
}

abstract class AbsListMiddleware<T> implements MiddlewareClass<ListState<T>> {
  List<T> _data = [];

  List<T> get data => _data;

  void set data(List<T> _data) {
    this._data = _data;
  }

  AbsListMiddleware() {
    print("AbsListMiddleware:$this");
  }

  @override
  void call(Store<ListState<T>> store, dynamic action, NextDispatcher next) {
    if (action is ListAction) {
      store.dispatch(ListLoadingAction());

      refresh()
          .then((result) => onResult(store, result, true))
          .catchError((e, s) => store..dispatch(ListErrorAction(e)));
    } else if (action is ListMoreAction) {
      //store.dispatch(ListLoadingAction());

      loadMore()
          .then((result) => onResult(store, result, false))
          .catchError((e, s) => store..dispatch(ListErrorAction(e)));
    }

    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }

  Future<List<T>> refresh();

  Future<List<T>> loadMore();

  onResult(Store<ListState<T>> store, result, bool refresh) {
    if (refresh) {
      _data.clear();
    }
    _data.addAll(result);
    store..dispatch(ListResultAction(_data));
  }
}
