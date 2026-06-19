import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';

/// A placeholder widget that shows a pulsing animated rectangle while content
/// is loading.
///
/// Use [NSkeleton] to indicate that a section of the UI is still being
/// prepared. It renders a rounded, muted container with a pulse animation.
///
/// ```dart
/// NSkeleton(width: 250, height: 16)
/// ```
class NSkeleton extends StatefulWidget {
  /// The width of the skeleton. When null, fills the available width.
  final double? width;

  /// The height of the skeleton. Defaults to 16.0.
  final double? height;

  /// The corner radius of the skeleton. Defaults to [NTokens.radiusSm].
  final double? borderRadius;

  /// Creates an [NSkeleton].
  const NSkeleton({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius,
  });

  @override
  State<NSkeleton> createState() => _NSkeletonState();
}

class _NSkeletonState extends State<NSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: NTokens.bgMuted(context),
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? NTokens.radiusSm,
              ),
            ),
          ),
        );
      },
    );
  }
}
