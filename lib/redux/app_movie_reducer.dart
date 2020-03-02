import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/redux/app_redux.dart';
import 'package:redux/redux.dart';

/// Reducer
final listReducer = combineReducers<ListState<Animate>>([
  TypedReducer<ListState<Animate>, ListLoadingAction>(_onLoad),
  TypedReducer<ListState<Animate>, ListErrorAction>(_onError),
  TypedReducer<ListState<Animate>, ListResultAction<Animate>>(_onResult),
  TypedReducer<ListState<Animate>, ListMoreResultAction<Animate>>(_onMore),
]);

ListState<Animate> _onLoad(ListState state, ListLoadingAction action) =>
    ListLoadingState();

ListState<Animate> _onError(ListState state, ListErrorAction action) =>
    ListErrorState(action.e);

ListState<Animate> _onResult(ListState state, ListResultAction action) =>
    ListPopulatedState(action.result, true);

ListState<Animate> _onMore(ListState state, ListMoreResultAction action) =>
    ListPopulatedState(action.result, false);
