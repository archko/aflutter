import 'dart:convert';

import 'package:AFlutter/entity/animate.dart';
import 'package:flutter_base/http/http_client.dart';
import 'package:flutter_base/http/http_response.dart';
import 'package:redux/redux.dart';

abstract class SearchState {}

class SearchInitial implements SearchState {}

class SearchLoading implements SearchState {}

class SearchEmpty implements SearchState {}

class SearchPopulated implements SearchState {
  final List<Animate> result;

  SearchPopulated(this.result);
}

class SearchError implements SearchState {}

/// Actions
class SearchAction {
  final String term;

  SearchAction(this.term);
}

class SearchLoadingAction {}

class SearchErrorAction {}

class SearchResultAction {
  final List<Animate> result;

  SearchResultAction(this.result);
}

/// Reducer
final searchReducer = combineReducers<SearchState>([
  TypedReducer<SearchState, SearchLoadingAction>(_onLoad),
  TypedReducer<SearchState, SearchErrorAction>(_onError),
  TypedReducer<SearchState, SearchResultAction>(_onResult),
]);

SearchState _onLoad(SearchState state, SearchLoadingAction action) =>
    SearchLoading();

SearchState _onError(SearchState state, SearchErrorAction action) =>
    SearchError();

SearchState _onResult(SearchState state, SearchResultAction action) =>
    action.result.isEmpty
        ? SearchEmpty()
        : SearchPopulated(action.result);

class SearchMiddleware implements MiddlewareClass<SearchState> {

  SearchMiddleware();

  @override
  void call(Store<SearchState> store, dynamic action, NextDispatcher next) {
    if (action is SearchAction) {
      store.dispatch(SearchLoadingAction());

      loadData()
          .then((result) => store..dispatch(SearchResultAction(result)))
          .catchError((e, s) => store..dispatch(SearchErrorAction()));
    }

    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }

  loadData() async {
    List<Animate> list;
    final String url =
        'https://sp0.baidu.com/8aQDcjqpAAV3otqbppnN2DJv/api.php?resource_id=28286&from_mid=1&&format=json&ie=utf-8&oe=utf-8&query=电影&sort_key=16&sort_type=1&stat0=&stat1=&stat2=&stat3=&pn=0&rn=25&cb=cbs';
    try {
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      var result = httpResponse.data.replaceAll('cbs(', '').replaceAll(')', '');
      print("result:$result");
      list = json
          .decode(result)['data'][0]['result']
          .map<Animate>((dynamic json) => Animate.fromJson(json))
          .toList();
    } catch (e) {
      print(e);
    }
    return list;
  }
}