import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:redux/redux.dart';

abstract class ListState {}

class ListInitialState implements ListState {}

class ListLoadingState implements ListState {}

class ListEmptyState implements ListState {}

class ListNoMoreState implements ListState {}

class ListPopulatedState implements ListState {
  final List<Animate> result;

  ListPopulatedState(this.result);
}

class ListErrorState implements ListState {}

/// Actions
class ListAction {
  final String term;

  ListAction(this.term);
}

class ListMoreAction {
  final String term;

  ListMoreAction(this.term);
}

class ListLoadingAction {}

class ListErrorAction {}

class ListResultAction {
  final List<Animate> result;

  ListResultAction(this.result);
}

class ListMoreResultAction {
  final List<Animate> result;

  ListMoreResultAction(this.result);
}

/// Reducer
final listReducer = combineReducers<ListState>([
  TypedReducer<ListState, ListLoadingAction>(_onLoad),
  TypedReducer<ListState, ListErrorAction>(_onError),
  TypedReducer<ListState, ListResultAction>(_onResult),
  TypedReducer<ListState, ListMoreResultAction>(_onMore),
]);

ListState _onLoad(ListState state, ListLoadingAction action) =>
    ListLoadingState();

ListState _onError(ListState state, ListErrorAction action) => ListErrorState();

ListState _onResult(ListState state, ListResultAction action) =>
    action.result.isEmpty
        ? ListEmptyState()
        : ListPopulatedState(action.result);

ListState _onMore(ListState state, ListMoreResultAction action) =>
    action.result.isEmpty
        ? ListNoMoreState()
        : ListPopulatedState(action.result);

class ListMiddleware implements MiddlewareClass<ListState> {
  ListMiddleware();

  @override
  void call(Store<ListState> store, dynamic action, NextDispatcher next) {
    if (action is ListAction) {
      store.dispatch(ListLoadingAction());

      refresh()
          .then((result) => store..dispatch(ListResultAction(result)))
          .catchError((e, s) => store..dispatch(ListErrorAction()));
    } else if (action is ListMoreAction) {
      //store.dispatch(ListLoadingAction());

      loadMore()
          .then((result) => store..dispatch(ListMoreResultAction(result)))
          .catchError((e, s) => store..dispatch(ListErrorAction()));
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
}
