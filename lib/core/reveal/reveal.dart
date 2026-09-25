import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'reveal_coordinator.dart';

/// Fades and lifts its child the first time it scrolls into view.
///
/// A no-op when the platform reports `disableAnimations`, so the site stays
/// usable for people who have asked the OS to reduce motion.
class Reveal extends StatefulWidget {
  const Reveal({
    required this.child,
    super.key,
    this.distance = 26,
    this.duration = const Duration(milliseconds: 640),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;

  /// How far below its final position the child starts, in logical pixels.
  final double distance;

  final Duration duration;

  /// Extra hold before animating, used to stagger grids.
  final Duration delay;

  final Curve curve;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  final GlobalKey _anchor = GlobalKey();

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  int _id = -1;
  bool _started = false;
  bool _reduceMotion = false;
  Timer? _delayTimer;

  /// Cached so dispose() never has to look up an inherited widget.
  RevealCoordinator? _coordinator;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // MediaQuery and the coordinator are both inherited, so they cannot be
    // read from initState.
    _reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_reduceMotion) {
      _controller.value = 1;
      _started = true;
    }

    if (_id == -1 && !_reduceMotion) {
      _coordinator = _coordinator ?? context.read<RevealCoordinator>();
      _id = _coordinator!.register(_anchor, onRevealed: _start);
    }
  }

  void _start() {
    if (_started || !mounted) return;
    _started = true;
    if (widget.delay == Duration.zero) {
      _controller.forward();
      return;
    }
    // Held so it can be cancelled in dispose() instead of outliving the widget.
    _delayTimer = Timer(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _delayTimer = null;
    if (_id != -1) _coordinator?.unregister(_id);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = KeyedSubtree(key: _anchor, child: widget.child);

    if (_reduceMotion) return content;

    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        final double t = _animation.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, widget.distance * (1 - t)),
            child: child,
          ),
        );
      },
      child: content,
    );
  }
}
