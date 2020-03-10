import 'package:AFlutter/redux/app_movie_reducer.dart';
import 'package:AFlutter/redux/theme_reducer.dart';
import 'package:AFlutter/state/app_state.dart';
import 'package:redux/redux.dart';

AppState appReducer(AppState appState, action) {
  return AppState(
      themeData: themeDataReducer(appState.themeData, action),
      movies: appMovieReducer(appState.movies, action));
}
