import 'package:AFlutter/widget/list/list_more_widget.dart';
import 'package:flutter/widgets.dart';

mixin ListState<T extends StatefulWidget> on State<T> {
  @protected
  LoadMoreStatus loadMoreStatus = LoadMoreStatus.IDLE;

  @protected
  setStatus(LoadMoreStatus status) {
    loadMoreStatus = status;
  }
}
