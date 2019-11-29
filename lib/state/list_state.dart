import 'package:flutter/widgets.dart';

import '../widget/list/load_more_status.dart';

mixin ListState<T extends StatefulWidget> on State<T> {
  @protected
  LoadMoreStatus loadMoreStatus = LoadMoreStatus.IDLE;

  @protected
  setStatus(LoadMoreStatus status) {
    loadMoreStatus = status;
  }
}
