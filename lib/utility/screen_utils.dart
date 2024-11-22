import 'package:flutter/cupertino.dart';

extension SizerExtensions on num {
  double get h =>
      (MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height /
          852) *
          this;

  double get w =>
      (MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width /
          393) *
          this;

  double get x => h * w;
}
