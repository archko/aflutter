import 'package:AFlutter/action/action.dart';
import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/redux/list_result.dart';
import 'package:redux/redux.dart';

/// Reducer
final movieReducer = combineReducers<ListResult<Animate>>([
  TypedReducer<ListResult<Animate>, ListResultAction<Animate>>(_onResult),
]);

ListResult<Animate> _onResult(ListResult state, ListResultAction action) =>
    ListResult(action.result, action.status, action.msg);
