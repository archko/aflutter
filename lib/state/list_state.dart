import 'package:flutter/widgets.dart';

import 'load_more_status.dart';

mixin ListState<T extends StatefulWidget> on State<T> {
  @protected
  LoadMoreStatus loadMoreStatus = LoadMoreStatus.IDLE;

  @protected
  setStatus(LoadMoreStatus status) {
    loadMoreStatus = status;
  }
}
