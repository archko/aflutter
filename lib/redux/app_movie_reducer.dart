import 'package:AFlutter/action/action.dart';
import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/redux/list_result.dart';
import 'package:redux/redux.dart';

/// Reducer
final appMovieReducer = combineReducers<ListResult<Animate>>([
  TypedReducer<ListResult<Animate>, ListResultAction<Animate>>(_onMovieResult),
]);

ListResult<Animate> _onMovieResult(ListResult state, ListResultAction action) =>
    ListResult(action.result, action.status, action.msg);
