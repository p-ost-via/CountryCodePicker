import 'dart:io';

import 'package:flutter/foundation.dart';

class PickerPlatform {
  static final bool isAndroid = !kIsWeb && Platform.isAndroid;

  static final bool isIOS = !kIsWeb && Platform.isIOS;

  static bool get isNotMobile => !isAndroid && !isIOS;

  static bool get isWeb => kIsWeb;

  static bool get isWebMobile =>
      kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  PickerPlatform._();
}
