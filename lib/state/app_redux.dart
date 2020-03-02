import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:redux/redux.dart';

abstract class ListState<T> {
  List<T> _data = [];

  List<T> get data => _data;

  void set data(List<T> _data) {
    this._data = _data;
  }
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

class ListResultAction {
  final List<Animate> result;

  ListResultAction(this.result);
}

class ListMoreResultAction {
  final List<Animate> result;

  ListMoreResultAction(this.result);
}

//================================

/// Reducer
final listReducer = combineReducers<ListState<Animate>>([
  TypedReducer<ListState<Animate>, ListLoadingAction>(_onLoad),
  TypedReducer<ListState<Animate>, ListErrorAction>(_onError),
  TypedReducer<ListState<Animate>, ListResultAction>(_onResult),
  TypedReducer<ListState<Animate>, ListMoreResultAction>(_onMore),
]);

ListState<Animate> _onLoad(ListState state, ListLoadingAction action) =>
    ListLoadingState();

ListState<Animate> _onError(ListState state, ListErrorAction action) =>
    ListErrorState(action.e);

ListState<Animate> _onResult(ListState state, ListResultAction action) =>
    ListPopulatedState(action.result, true);

ListState<Animate> _onMore(ListState state, ListMoreResultAction action) =>
    ListPopulatedState(action.result, false);

class ListMiddleware implements MiddlewareClass<ListState<Animate>> {
  List<Animate> _data = [];

  ListMiddleware() {
    print("ListMiddleware:$ListMiddleware");
  }

  @override
  void call(
      Store<ListState<Animate>> store, dynamic action, NextDispatcher next) {
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

  refresh() async {
    List<Animate> list = await MovieViewModel().loadData(0);
    return list;
  }

  loadMore() async {
    List<Animate> list = await MovieViewModel().loadMore(0);
    return list;
  }

  onResult(Store<ListState<Animate>> store, result, bool refresh) {
    if (refresh) {
      _data.clear();
    }
    _data.addAll(result);
    store..dispatch(ListResultAction(_data));
  }
}
