import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  bool get isTablet {
    final mediaQuery = MediaQuery.of(this);
    final size = mediaQuery.size;
    final dpr = mediaQuery.devicePixelRatio;
    return (size.height / dpr > 720.0 && size.width / dpr >= 728.0);
  }
}
