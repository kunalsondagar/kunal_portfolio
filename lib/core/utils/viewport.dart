import 'dart:ui' show FlutterView;

import 'package:flutter/widgets.dart';

/// The window's logical height, read from the [FlutterView].
///
/// Used instead of a scroll view's context so scroll observers can measure the
/// viewport without needing a `BuildContext` of their own.
double? viewportHeightOf(BuildContext context) {
  final FlutterView? view = View.maybeOf(context);
  if (view == null) return null;
  final double ratio = view.devicePixelRatio;
  if (ratio <= 0) return null;
  return view.physicalSize.height / ratio;
}
