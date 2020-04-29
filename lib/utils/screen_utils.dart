import 'package:flutter/widgets.dart';

class ScreenUtils {
  static double getSafeBottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static double getSafeTopPadding(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
