import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

/// The size of an [NProgress] bar, controlling its thickness.
enum NProgressSize {
  /// Extra small (2 dp).
  xs,

  /// Small (4 dp).
  sm,

  /// Medium (6 dp). The default size.
  md,

  /// Large (8 dp).
  lg,

  /// Extra large (12 dp).
  xl,
}

/// The semantic color role applied to an [NProgress] indicator.
enum NProgressColor {
  /// Uses [NTokens.primary].
  primary,

  /// Uses [NTokens.success].
  success,

  /// Uses [NTokens.warning].
  warning,

  /// Uses [NTokens.error].
  error,

  /// Uses [NTokens.info].
  info,

  /// Uses a neutral color.
  neutral,
}

/// A linear progress bar that displays the progress of a task.
///
/// Supports determinate mode (when [value] is between 0 and 1) and
/// indeterminate mode (when [value] is null). The bar animates smoothly
/// between value changes.
///
/// ```dart
/// NProgress(value: 0.5, color: NProgressColor.primary)
/// ```
class NProgress extends StatelessWidget {
  /// The current progress value between 0.0 and 1.0.
  ///
  /// When null, the progress bar runs in indeterminate mode with a looping
  /// animation.
  final double? value;

  /// The thickness of the bar. Defaults to [NProgressSize.md].
  final NProgressSize size;

  /// The semantic color of the filled indicator. Defaults to
  /// [NProgressColor.primary].
  final NProgressColor color;

  /// When true, renders the bar from right to left. Defaults to false.
  final bool inverted;

  /// Creates an [NProgress] bar.
  const NProgress({
    super.key,
    this.value,
    this.size = NProgressSize.md,
    this.color = NProgressColor.primary,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    final thickness = _getThickness();
    final c = NComponentColors.resolve(context, _componentColor());
    final indicatorColor = c.main;

    return ClipRRect(
      borderRadius: BorderRadius.circular(thickness / 2),
      child: SizedBox(
        width: double.infinity,
        height: thickness,
        child: value == null
            ? _IndeterminateBar(color: indicatorColor, inverted: inverted)
            : _DeterminateBar(
                value: value!, color: indicatorColor, inverted: inverted),
      ),
    );
  }

  NComponentColor _componentColor() {
    return switch (color) {
      NProgressColor.primary => NComponentColor.primary,
      NProgressColor.success => NComponentColor.success,
      NProgressColor.warning => NComponentColor.warning,
      NProgressColor.error => NComponentColor.error,
      NProgressColor.info => NComponentColor.info,
      NProgressColor.neutral => NComponentColor.neutral,
    };
  }

  double _getThickness() {
    switch (size) {
      case NProgressSize.xs:
        return 2;
      case NProgressSize.sm:
        return 4;
      case NProgressSize.md:
        return 6;
      case NProgressSize.lg:
        return 8;
      case NProgressSize.xl:
        return 12;
    }
  }
}

class _DeterminateBar extends StatelessWidget {
  final double value;
  final Color color;
  final bool inverted;

  const _DeterminateBar({
    required this.value,
    required this.color,
    required this.inverted,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: NTokens.bgAccented(context),
                borderRadius:
                    BorderRadius.circular(constraints.maxHeight / 2),
              ),
            ),
            AnimatedFractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              heightFactor: 1,
              alignment: inverted ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                      BorderRadius.circular(constraints.maxHeight / 2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _IndeterminateBar extends StatefulWidget {
  final Color color;
  final bool inverted;

  const _IndeterminateBar({
    required this.color,
    required this.inverted,
  });

  @override
  State<_IndeterminateBar> createState() => _IndeterminateBarState();
}

class _IndeterminateBarState extends State<_IndeterminateBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: NTokens.bgAccented(context),
                borderRadius:
                    BorderRadius.circular(constraints.maxHeight / 2),
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return FractionalTranslation(
                  translation: _animation.value,
                  child: FractionallySizedBox(
                    widthFactor: widget.inverted ? 0.4 : 0.3,
                    heightFactor: 1,
                    alignment: widget.inverted
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius:
                            BorderRadius.circular(constraints.maxHeight / 2),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
