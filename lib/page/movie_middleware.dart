import 'package:AFlutter/action/action.dart';
import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:AFlutter/redux/list_result.dart';
import 'package:AFlutter/redux/list_state.dart';
import 'package:redux/redux.dart';

List<Middleware<ListState<Animate>>> createMoviesMiddleware() {
  final loadMovies = _createLoadMovies();
  final refreshMovies = _createLoadMovies();
  final loadMoreMovies = _createLoadMoreMovies();

  return [
    TypedMiddleware<ListState<Animate>, ListAction>(loadMovies),
    //TypedMiddleware<ListState<Animate>, ListAction>(refreshMovies),
    TypedMiddleware<ListState<Animate>, ListMoreAction>(loadMoreMovies),
  ];
}

Middleware<ListState<Animate>> _createLoadMovies() {
  return (Store<ListState<Animate>> store, action, NextDispatcher next) {
    MovieViewModel().loadData(store.state.pageIndex).then(
      (movies) {
        if (movies != null) {
          store.dispatch(
            ListResultAction(movies, ListStatus.success, null),
          );
        } else {
          store.dispatch(
            ListResultAction(movies, ListStatus.empty, null),
          );
        }
      },
    ).catchError((e) => store.dispatch(
          ListResultAction(null, ListStatus.error, e.toString()),
        ));

    next(action);
  };
}

Middleware<ListState<Animate>> _createLoadMoreMovies() {
  return (Store<ListState<Animate>> store, action, NextDispatcher next) {
    MovieViewModel().loadMore(store.state.pageIndex + 1).then(
      (movies) {
        if (movies != null) {
          store.dispatch(
            ListMoreResultAction(movies, ListStatus.success, null),
          );
        } else {
          store.dispatch(
            ListMoreResultAction(movies, ListStatus.nomore, null),
          );
        }
      },
    ).catchError((e) => store.dispatch(
          ListMoreResultAction(null, ListStatus.error, e.toString()),
        ));

    next(action);
  };
}
