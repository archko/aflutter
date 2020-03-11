import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FPage<S, ViewModel> extends StatefulWidget {
  final Reducer<S> reducer;
  final OnInitCallback<S> onInit;
  final StoreConverter<S, ViewModel> converter;
  final List<Middleware<S>> middleware;
  final S initialState;
  final ViewModelBuilder<ViewModel> builder;

  FPage(
      {Key key,
      this.builder,
      this.reducer,
      this.converter,
      this.onInit,
      this.middleware,
      this.initialState})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FPageState<S, ViewModel>();
  }
}

class FPageState<S, ViewModel> extends State<FPage<S, ViewModel>> {
  @override
  Widget build(BuildContext context) {
    Store<S> astore = Store<S>(
      widget.reducer,
      middleware: widget.middleware,
      initialState: widget.initialState,
    );
    return StoreProvider<S>(
      store: astore,
      child: buildRedux(context),
    );
  }

  Widget buildRedux(BuildContext context) {
    return StoreConnector<S, ViewModel>(
      onInit: widget.onInit,
      converter: widget.converter,
      builder: widget.builder,
    );
  }
}
