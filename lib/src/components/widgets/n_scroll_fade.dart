import 'package:flutter/material.dart';
import 'package:nui_flutter/src/theme/n_tokens.dart';

/// Wraps a scrollable widget and overlays gradient fade effects at edges.
///
/// The [scrollController] MUST be the same controller passed to the inner
/// scrollable (ListView, CustomScrollView, etc.) so the listener can track
/// the scroll offset without resetting it on rebuild.
///
/// Example:
/// ```dart
/// final _ctrl = ScrollController();
///
/// TScrollFade(
///   scrollController: _ctrl,
///   child: ListView(controller: _ctrl, ...),
/// )
/// ```
class NScrollFade extends StatefulWidget {
  /// The scrollable widget. Its controller must match [scrollController].
  final Widget child;

  /// Controller shared with the inner scrollable.
  final ScrollController scrollController;

  /// Show the top fade when scrolled down.
  final bool fadeTop;

  /// Show the bottom fade when not at the bottom.
  final bool fadeBottom;

  /// Height of each fade gradient (default 40).
  final double fadeHeight;

  /// Scroll threshold (px) before fades appear/disappear (default 10).
  final double threshold;

  /// Background color for the gradient. Defaults to [scaffoldBackgroundColor].
  final Color? color;

  const NScrollFade({
    super.key,
    required this.child,
    required this.scrollController,
    this.fadeTop = true,
    this.fadeBottom = true,
    this.fadeHeight = 40,
    this.threshold = 10,
    this.color,
  });

  @override
  State<NScrollFade> createState() => _NScrollFadeState();
}

class _NScrollFadeState extends State<NScrollFade> {
  bool _showTopFade = false;
  bool _showBottomFade = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(NScrollFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final offset = widget.scrollController.offset;
    final maxScroll = widget.scrollController.position.maxScrollExtent;

    final showTop = widget.fadeTop && offset > widget.threshold;
    final showBottom =
        widget.fadeBottom && offset < (maxScroll - widget.threshold);

    if (showTop != _showTopFade || showBottom != _showBottomFade) {
      setState(() {
        _showTopFade = showTop;
        _showBottomFade = showBottom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.color ?? NTokens.bgDefault(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,

        // ── Top fade ────────────────────────────────────────────────────────
        if (widget.fadeTop)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: _showTopFade ? 1.0 : 0.0,
                child: Container(
                  height: widget.fadeHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [bgColor, bgColor.withValues(alpha: 0)],
                    ),
                  ),
                ),
              ),
            ),
          ),

        // ── Bottom fade ─────────────────────────────────────────────────────
        if (widget.fadeBottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: _showBottomFade ? 1.0 : 0.0,
                child: Container(
                  height: widget.fadeHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [bgColor, bgColor.withValues(alpha: 0)],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
