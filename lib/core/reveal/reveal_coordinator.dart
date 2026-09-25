import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/viewport.dart';

/// Tracks which scroll-registered widgets have entered the viewport so that
/// [Reveal] animations fire exactly once.
///
/// One [ScrollController] is attached at a time (the active route's), so a
/// single pass per scroll tick is enough no matter how many widgets are on
/// screen.
class RevealCoordinator extends ChangeNotifier {
  RevealCoordinator();

  /// Fraction of the viewport height a widget must reach before revealing.
  static const double triggerRatio = 0.88;

  ScrollController? _controller;
  final Map<int, GlobalKey> _anchors = <int, GlobalKey>{};
  final Map<int, VoidCallback> _onRevealed = <int, VoidCallback>{};
  final Set<int> _fired = <int>{};

  int _nextId = 0;
  bool _evaluationScheduled = false;

  /// Starts observing [controller]. Re-attaching the same controller is a no-op,
  /// so a rebuild never disturbs widgets that already registered.
  void attach(ScrollController controller) {
    if (identical(_controller, controller)) return;
    _controller?.removeListener(_evaluate);
    _controller = controller;
    controller.addListener(_evaluate);
    _scheduleEvaluate();
  }

  void detach() {
    _controller?.removeListener(_evaluate);
    _controller = null;
    _anchors.clear();
    _fired.clear();
  }

  /// Registers a widget's anchor. Returns the id used to [unregister] it and
  /// to receive the reveal callback from [onRevealed].
  int register(GlobalKey anchor, {required VoidCallback onRevealed}) {
    final int id = _nextId++;
    _anchors[id] = anchor;
    _onRevealed[id] = onRevealed;
    // Widgets that are already on screen when they register (above the fold, or
    // after a resize) would otherwise wait for a scroll that never comes.
    _scheduleEvaluate();
    return id;
  }

  void unregister(int id) {
    _anchors.remove(id);
    _onRevealed.remove(id);
    _fired.remove(id);
  }

  /// Re-runs the check immediately, e.g. after a viewport resize.
  void reevaluate() => _evaluate();

  void _scheduleEvaluate() {
    if (_evaluationScheduled) return;
    _evaluationScheduled = true;
    scheduleMicrotask(() {
      _evaluationScheduled = false;
      _evaluate();
    });
  }

  void _evaluate() {
    if (_anchors.isEmpty) return;

    final ScrollController? controller = _controller;
    if (controller == null || !controller.hasClients) return;

    // Snapshot: firing a callback can dispose widgets, which mutates the maps.
    final List<int> ids = _anchors.keys.toList(growable: false);

    double? triggerLine;

    for (final int id in ids) {
      if (_fired.contains(id)) continue;

      final BuildContext? context = _anchors[id]?.currentContext;
      if (context == null || !context.mounted) continue;

      final RenderObject? renderObject = context.findRenderObject();
      if (renderObject is! RenderBox ||
          !renderObject.hasSize ||
          !renderObject.attached) {
        continue;
      }

      // The viewport height is the same for every anchor, so it is only looked
      // up once per pass.
      triggerLine ??= viewportHeightOf(context);
      if (triggerLine == null) return;

      if (renderObject.localToGlobal(Offset.zero).dy <=
          triggerLine * triggerRatio) {
        _fired.add(id);
        _onRevealed[id]?.call();
      }
    }
  }

  @override
  void dispose() {
    detach();
    _onRevealed.clear();
    super.dispose();
  }
}
