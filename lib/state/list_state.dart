import 'package:flutter/widgets.dart';

import 'load_more_status.dart';

mixin ListState<T extends StatefulWidget> on State<T> {
  @protected
  LoadMoreStatus loadMoreStatus;

  @protected
  refresh() async {}

  @protected
  loadMore() async {}
}
