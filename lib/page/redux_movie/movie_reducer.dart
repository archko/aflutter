import 'package:AFlutter/action/action.dart';
import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/redux/list_state.dart';
import 'package:redux/redux.dart';

/// Reducer
final movieReducer = combineReducers<ListState<Animate>>([
  TypedReducer<ListState<Animate>, ListResultAction<Animate>>(_onResult),
  TypedReducer<ListState<Animate>, ListMoreResultAction<Animate>>(
      _onMoreResult),
]);

ListState<Animate> _onResult(
        ListState<Animate> state, ListResultAction<Animate> action) =>
    state.clone()
      ..list = action.result
      ..pageIndex = 0
      ..loadStatus = action.status;

ListState<Animate> _onMoreResult(
        ListState<Animate> state, ListMoreResultAction<Animate> action) =>
    state.clone()
      ..list.addAll(action.result)
      ..pageIndex = state.pageIndex + 1
      ..loadStatus = action.status;
