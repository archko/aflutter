enum LoadMoreStatus {
  /// 空闲中，表示当前等待加载
  ///
  /// wait for loading
  IDLE,

  /// 刷新中，不应该继续加载，等待future返回
  ///
  /// the view is loading
  LOADING,

  /// 刷新失败，刷新失败，这时需要点击才能刷新
  ///
  /// loading fail, need tap view to loading
  FAIL,

  /// 没有更多，没有更多数据了，这个状态不触发任何条件
  ///
  /// not have more data
  NOMORE,
  //no item
  EMPTY,
}
