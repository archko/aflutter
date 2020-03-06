import 'package:AFlutter/action/action.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:AFlutter/redux/list_result.dart';
import 'package:AFlutter/redux/app_redux.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreMoviesMiddleware() {
  final loadMovies = _createLoadMovies();
  final loadMoreMovies = _createLoadMoreMovies();

  return [
    TypedMiddleware<AppState, ListAction>(loadMovies),
    TypedMiddleware<AppState, ListMoreAction>(loadMoreMovies),
  ];
}

Middleware<AppState> _createLoadMovies() {
  return (Store<AppState> store, action, NextDispatcher next) {
    MovieViewModel().loadData(0).then(
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

Middleware<AppState> _createLoadMoreMovies() {
  return (Store<AppState> store, action, NextDispatcher next) {
    MovieViewModel().loadMore(0).then(
      (movies) {
        if (movies != null) {
          store.dispatch(
            ListResultAction(movies, ListStatus.success, null),
          );
        } else {
          store.dispatch(
            ListResultAction(movies, ListStatus.nomore, null),
          );
        }
      },
    ).catchError((e) => store.dispatch(
          ListResultAction(null, ListStatus.error, e.toString()),
        ));

    next(action);
  };
}
