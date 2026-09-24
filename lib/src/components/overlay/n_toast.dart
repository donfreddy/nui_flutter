import 'package:nui_flutter/nui_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';

/// The layout orientation of an [NToast] icon and message content.
enum NToastOrientation {
  /// Icon and message are arranged side by side in a row.
  horizontal,

  /// Icon and message are stacked in a column.
  vertical,
}

/// The screen position where the [NToast] will be displayed.
enum NToastPosition {
  /// Displays the toast at the top of the screen.
  top,

  /// Displays the toast at the bottom of the screen.
  bottom,
}

/// A succinct message that provides information or feedback to the user.
///
/// Display [NToast] by calling [NToast.show] with a [BuildContext]. The toast
/// appears as an overlay at the bottom of the screen and auto-dismisses after
/// a configurable duration.
///
/// Mirrors Nuxt UI's `UToast`: the surface is always a neutral, opaque
/// background with a neutral border, in both light and dark mode. Only the
/// [icon] (and the default severity icon) is tinted by [color]; title and
/// description stay neutral. There is no colored "fill" variant.
///
/// ```dart
/// NToast.show(
///   context,
///   title: 'Payment sent',
///   description: 'Your transfer was successful.',
///   color: NColorRole.success,
/// )
/// ```
class NToast extends StatelessWidget {
  /// The bold title text shown in the toast.
  final String? title;

  /// A secondary description shown below [title].
  final String? description;

  /// An optional icon displayed before the text.
  final IconData? icon;

  /// Whether to show the default icon when no custom [icon] is provided.
  /// Defaults to true.
  final bool showIcon;

  /// The semantic color role. Defaults to [NColorRole.primary].
  ///
  /// Only tints the icon; the toast surface stays neutral.
  final NColorRole color;

  /// The position of the toast on the screen.
  /// Defaults to [NToastPosition.bottom].
  final NToastPosition position;

  /// The layout orientation of the actions relative to the content.
  /// Defaults to [NToastOrientation.vertical].
  final NToastOrientation orientation;

  /// When true, a close button is rendered at the trailing edge.
  final bool closable;

  /// When true, the toast can be dismissed by dragging it vertically.
  final bool dragToClose;

  /// An optional avatar displayed before the text.
  final Widget? avatar;

  /// A list of actions displayed based on the [orientation].
  final List<Widget>? actions;

  /// The animation used for the progress bar. If null, no progress bar is shown.
  final Animation<double>? progressAnimation;

  /// Called when the close button is tapped.
  final VoidCallback? onClose;

  /// Called when the toast is tapped.
  final VoidCallback? onTap;

  /// Creates an [NToast] widget.
  const NToast({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.avatar,
    this.actions,
    this.progressAnimation,
    this.color = NColorRole.primary,
    this.position = NToastPosition.bottom,
    this.orientation = NToastOrientation.vertical,
    this.closable = true,
    this.showIcon = true,
    this.dragToClose = false,
    this.onClose,
    this.onTap,
  });

  /// Shows a toast.
  ///
  /// When an [NToaster] ancestor is found, the toast is added to its
  /// managed stack (proper offsetting when several toasts are visible at
  /// once, a [NToaster.max] cap, and optional expand-on-hover). Without one,
  /// it falls back to a standalone screen-anchored overlay exactly as
  /// before: simplest for a single toast at a time, but concurrent toasts
  /// will visually overlap since nothing coordinates their position. Wrap
  /// your app root in [NToaster] to get stacking.
  ///
  /// The toast automatically dismisses after [duration] (defaults to 5
  /// seconds, matching Nuxt UI). Pass [duration] as Duration.zero to make it
  /// persistent until manually dismissed. Set [pauseOnTouch] to true to pause
  /// auto-dismiss and progress while the user is touching the toast.
  ///
  /// Returns an id that can be passed to [NToaster.dismiss] (managed case
  /// only; a no-op id otherwise).
  static Object show(
    BuildContext context, {
    String? title,
    String? description,
    IconData? icon,
    Widget? avatar,
    List<Widget>? actions,
    NColorRole color = NColorRole.primary,
    NToastPosition position = NToastPosition.bottom,
    NToastOrientation orientation = NToastOrientation.vertical,
    bool closable = true,
    bool showIcon = true,
    bool dragToClose = false,
    bool pauseOnTouch = true,
    bool progress = true,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onTap,
  }) {
    final toaster = NToaster.maybeOf(context);
    if (toaster != null) {
      return toaster.show(
        title: title,
        description: description,
        icon: icon,
        avatar: avatar,
        actions: actions,
        color: color,
        position: position,
        orientation: orientation,
        closable: closable,
        showIcon: showIcon,
        dragToClose: dragToClose,
        pauseOnTouch: pauseOnTouch,
        progress: progress,
        duration: duration,
        onTap: onTap,
      );
    }

    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    final id = UniqueKey();

    entry = OverlayEntry(
      builder: (ctx) => _NToastOverlay(
        title: title,
        description: description,
        icon: icon,
        avatar: avatar,
        actions: actions,
        color: color,
        position: position,
        orientation: orientation,
        closable: closable,
        dragToClose: dragToClose,
        pauseOnTouch: pauseOnTouch,
        showIcon: showIcon,
        progress: progress,
        duration: duration,
        onClose: () {
          if (entry.mounted) {
            entry.remove();
          }
        },
        onTap: onTap,
      ),
    );

    overlay.insert(entry);
    return id;
  }

  @override
  Widget build(BuildContext context) {
    final styles = _getStyles(context);
    final defaultIcon = _getDefaultIcon();

    final toast = GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: styles.background,
          borderRadius: context.nui.radius.radiusLg,
          border: Border.all(color: styles.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: context.nui.radius.radiusLg,
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (avatar != null) ...[
                        avatar!,
                        NSpacing.horizontal(NSpacing.standard.s2),
                      ] else if (icon != null ||
                          (showIcon && defaultIcon != null)) ...[
                        Icon(
                          icon ?? defaultIcon,
                          size: 20,
                          color: styles.icon,
                        ),
                        NSpacing.horizontal(NSpacing.standard.s2),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (title != null)
                              Text(
                                title!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: styles.title,
                                ),
                              ),
                            if (description != null) ...[
                              if (title != null) const SizedBox(height: 4),
                              Text(
                                description!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: styles.description,
                                ),
                              ),
                            ],
                            if (orientation == NToastOrientation.vertical &&
                                actions != null &&
                                actions!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: actions!,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (orientation == NToastOrientation.horizontal &&
                          actions != null &&
                          actions!.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < actions!.length; i++) ...[
                              actions![i],
                              if (i < actions!.length - 1)
                                const SizedBox(width: 8),
                            ],
                          ],
                        ),
                      ],
                      if (closable) ...[
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: onClose,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: styles.description,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (progressAnimation != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedBuilder(
                      animation: progressAnimation!,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: progressAnimation!.value,
                          minHeight: 3,
                          backgroundColor: Colors.transparent,
                          color: styles.icon,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!dragToClose) {
      return toast;
    }

    return _NToastDragToClose(
      onClose: onClose,
      child: toast,
    );
  }

  /// Resolves the neutral surface plus the [color]-tinted icon, mirroring
  /// Nuxt UI's toast theme: `bg-default ring ring-default`, `text-highlighted`
  /// title, `text-muted` description, and only `text-{color}` on the icon.
  _NToastStyles _getStyles(BuildContext context) {
    final colors = context.nui.colors;
    final isDark = colors.brightness == Brightness.dark;
    // Deliberately `textHighlighted` (not `colors.text`, unlike the ghost
    // variant in NVariantResolver) for the neutral case: matches Nuxt UI's
    // real toast theme, where both the title and a neutral icon use
    // `text-highlighted`.
    final iconColor = color == NColorRole.neutral
        ? colors.textHighlighted
        : (isDark ? colors.scaleFor(color).textDark : colors.scaleFor(color).s500);
    return _NToastStyles(
      background: colors.bg,
      border: colors.border,
      title: colors.textHighlighted,
      description: colors.textMuted,
      icon: iconColor,
    );
  }

  IconData? _getDefaultIcon() {
    switch (color) {
      case NColorRole.info:
        return Icons.info_outline;
      case NColorRole.success:
        return Icons.check_circle_outline;
      case NColorRole.warning:
        return Icons.warning_amber_outlined;
      case NColorRole.error:
        return Icons.error_outline;
      case NColorRole.primary:
        return Icons.lightbulb_outline;
      case NColorRole.neutral:
      case NColorRole.secondary:
        return null;
    }
  }
}

/// Manages and stacks multiple [NToast]s shown via [NToast.show], mirroring
/// Nuxt UI's toaster / shadcn_ui's `ShadSonner`.
///
/// Wrap your app root in [NToaster] so concurrent toasts are offset instead
/// of drawing on top of each other (the failure mode of [NToast.show]
/// without one). At most [max] toasts are shown at once; adding one beyond
/// that gracefully dismisses the oldest.
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => NToaster(child: child!),
///   home: const HomePage(),
/// )
/// ```
///
/// By default, extra toasts behind the front one only peek out slightly
/// (scaled down, offset a few pixels) and are not interactive: dismissing
/// the front toast reveals the next one. On desktop/web, hovering the stack
/// expands it into a full list; set [expand] to `true` to always show it
/// expanded (no peek/collapse at all, no hover needed).
class NToaster extends StatefulWidget {
  /// The widget below the toaster in the tree, over which toasts are shown.
  final Widget child;

  /// The default corner for toasts that don't specify their own [NToast.show]
  /// `position`. Defaults to [NToastPosition.bottom].
  final NToastPosition position;

  /// The maximum number of toasts visible at once. Defaults to `3`.
  ///
  /// Showing one more evicts (gracefully dismisses) the oldest.
  final int max;

  /// When `true`, always lays the stack out as a full vertical list instead
  /// of a collapsed peek. Defaults to `false`.
  final bool expand;

  /// The gap between toasts when [expand] (or hover-expanded).
  final double gap;

  const NToaster({
    super.key,
    required this.child,
    this.position = NToastPosition.bottom,
    this.max = 3,
    this.expand = false,
    this.gap = 8,
  });

  /// Retrieves the nearest [NToasterState], or throws if none is found.
  static NToasterState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'No NToaster found in the widget tree above this context.');
    return state!;
  }

  /// Retrieves the nearest [NToasterState], or `null` if none is found.
  static NToasterState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<NToasterState>();
  }

  @override
  State<NToaster> createState() => NToasterState();
}

class _ManagedToast {
  _ManagedToast({
    required this.id,
    required this.position,
    required this.key,
    required this.builder,
  });

  final Object id;
  final NToastPosition position;
  final GlobalKey<_NToastOverlayState> key;
  final Widget Function(VoidCallback onClose) builder;

  /// Measured render height, updated by [_MeasureSize] once laid out.
  /// Used for the expanded (non-collapsed) stack layout.
  double height = 0;
}

class NToasterState extends State<NToaster> {
  final List<_ManagedToast> _toasts = [];
  bool _hoverExpanded = false;

  /// Shows a managed toast. Mirrors [NToast.show]'s parameters exactly.
  Object show({
    String? title,
    String? description,
    IconData? icon,
    Widget? avatar,
    List<Widget>? actions,
    NColorRole color = NColorRole.primary,
    NToastPosition? position,
    NToastOrientation orientation = NToastOrientation.vertical,
    bool closable = true,
    bool showIcon = true,
    bool dragToClose = false,
    bool pauseOnTouch = true,
    bool progress = true,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onTap,
  }) {
    final id = UniqueKey();
    final effectivePosition = position ?? widget.position;
    final key = GlobalKey<_NToastOverlayState>();

    final entry = _ManagedToast(
      id: id,
      position: effectivePosition,
      key: key,
      builder: (onClose) => _NToastOverlay(
        key: key,
        title: title,
        description: description,
        icon: icon,
        avatar: avatar,
        actions: actions,
        color: color,
        position: effectivePosition,
        orientation: orientation,
        closable: closable,
        dragToClose: dragToClose,
        pauseOnTouch: pauseOnTouch,
        showIcon: showIcon,
        progress: progress,
        duration: duration,
        onTap: onTap,
        onClose: onClose,
        managed: true,
      ),
    );

    setState(() {
      _toasts.add(entry);
      // Evict oldest-first until back under the cap; each eviction plays
      // its own exit animation rather than vanishing abruptly.
      final overflow = _toasts.length - widget.max;
      for (var i = 0; i < overflow; i++) {
        _toasts[i].key.currentState?._dismiss();
      }
    });

    return id;
  }

  /// Gracefully dismisses the managed toast with the given [id] (as
  /// returned by [show] / [NToast.show]). No-op if not found.
  void dismiss(Object id) {
    for (final toast in _toasts) {
      if (toast.id == id) {
        toast.key.currentState?._dismiss();
        return;
      }
    }
  }

  void _remove(Object id) {
    if (!mounted) return;
    setState(() => _toasts.removeWhere((t) => t.id == id));
  }

  /// Bottom/top position (distance from the container's leading edge, i.e.
  /// the front/newest toast is index `n - 1`) for a collapsed peek stack.
  List<double> _collapsedOffsets(int n) =>
      [for (var i = 0; i < n; i++) (n - 1 - i) * 10.0];

  /// Same, but for the expanded list: cumulative measured heights + [gap].
  List<double> _expandedOffsets(List<_ManagedToast> toasts) {
    final offsets = List<double>.filled(toasts.length, 0);
    var cumulative = 0.0;
    for (var i = toasts.length - 1; i >= 0; i--) {
      offsets[i] = cumulative;
      cumulative += (toasts[i].height > 0 ? toasts[i].height : 56) + widget.gap;
    }
    return offsets;
  }

  Widget _buildGroup(BuildContext context, List<_ManagedToast> toasts, bool isBottom) {
    final expanded = widget.expand || _hoverExpanded;
    final n = toasts.length;
    final collapsed = _collapsedOffsets(n);
    final expandedOffsets = _expandedOffsets(toasts);
    // The expanded total is always >= the collapsed peek extent, so it's a
    // safe (if occasionally over-generous) height for the hit-testable
    // region regardless of which layout is currently active.
    final totalHeight =
        expandedOffsets.isEmpty ? 0.0 : expandedOffsets[0] + (toasts[0].height > 0 ? toasts[0].height : 56);

    return MouseRegion(
      onEnter: (_) => setState(() => _hoverExpanded = true),
      onExit: (_) => setState(() => _hoverExpanded = false),
      child: SizedBox(
        width: double.infinity,
        height: totalHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < n; i++)
              AnimatedPositioned(
                key: ValueKey(toasts[i].id),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                left: 16,
                right: 16,
                bottom: isBottom ? (expanded ? expandedOffsets[i] : collapsed[i]) : null,
                top: isBottom ? null : (expanded ? expandedOffsets[i] : collapsed[i]),
                child: IgnorePointer(
                  ignoring: !expanded && n - 1 - i != 0,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    scale: expanded ? 1.0 : (1.0 - (n - 1 - i) * 0.05).clamp(0.85, 1.0),
                    alignment: isBottom ? Alignment.bottomCenter : Alignment.topCenter,
                    child: _MeasureSize(
                      onChange: (size) {
                        if ((toasts[i].height - size.height).abs() > 0.5) {
                          setState(() => toasts[i].height = size.height);
                        }
                      },
                      child: toasts[i].builder(() => _remove(toasts[i].id)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomToasts = _toasts.where((t) => t.position == NToastPosition.bottom).toList();
    final topToasts = _toasts.where((t) => t.position == NToastPosition.top).toList();

    return Stack(
      children: [
        widget.child,
        if (bottomToasts.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: _buildGroup(context, bottomToasts, true),
          ),
        if (topToasts.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            top: topPadding + 24,
            child: _buildGroup(context, topToasts, false),
          ),
      ],
    );
  }
}

/// Reports [child]'s rendered size to [onChange] after every layout in
/// which it changed. Used by [NToasterState] to lay out the expanded stack
/// from each toast's real (possibly multi-line) height.
class _MeasureSize extends StatefulWidget {
  const _MeasureSize({required this.child, required this.onChange});

  final Widget child;
  final ValueChanged<Size> onChange;

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  final _key = GlobalKey();
  Size? _lastSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _report());
    return Container(key: _key, child: widget.child);
  }

  void _report() {
    if (!mounted) return;
    final size = _key.currentContext?.size;
    if (size != null && size != _lastSize) {
      _lastSize = size;
      widget.onChange(size);
    }
  }
}

class _NToastStyles {
  final Color background;
  final Color border;
  final Color title;
  final Color description;
  final Color icon;

  const _NToastStyles({
    required this.background,
    required this.border,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _NToastDragToClose extends StatefulWidget {
  final Widget child;
  final VoidCallback? onClose;

  const _NToastDragToClose({
    required this.child,
    this.onClose,
  });

  @override
  State<_NToastDragToClose> createState() => _NToastDragToCloseState();
}

class _NToastDragToCloseState extends State<_NToastDragToClose> {
  double _dragOffset = 0;
  bool _closing = false;

  void _onDragUpdate(DragUpdateDetails details) {
    if (_closing) return;
    setState(() {
      _dragOffset += details.delta.dy;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_closing) return;

    const distanceThreshold = 80.0;
    const velocityThreshold = 700.0;
    final velocity = details.primaryVelocity ?? 0;

    if (_dragOffset.abs() > distanceThreshold ||
        velocity.abs() > velocityThreshold) {
      _closing = true;
      widget.onClose?.call();
    } else {
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: Transform.translate(
        offset: Offset(0, _dragOffset),
        child: widget.child,
      ),
    );
  }
}

/// Internal widget that manages toast overlay lifecycle with animation.
class _NToastOverlay extends StatefulWidget {
  final String? title;
  final String? description;
  final IconData? icon;
  final Widget? avatar;
  final List<Widget>? actions;
  final NColorRole color;
  final NToastPosition position;
  final NToastOrientation orientation;
  final bool closable;
  final bool dragToClose;
  final bool pauseOnTouch;
  final bool showIcon;
  final bool progress;
  final Duration duration;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  /// When `true`, this instance is positioned externally by an [NToaster]
  /// stack, so [_NToastOverlayState.build] skips its own [Positioned] and
  /// entrance [SlideTransition] offset is relative rather than
  /// screen-anchored. See [NToaster].
  final bool managed;

  const _NToastOverlay({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.avatar,
    this.actions,
    required this.color,
    required this.position,
    required this.orientation,
    required this.closable,
    required this.dragToClose,
    required this.pauseOnTouch,
    required this.showIcon,
    required this.progress,
    required this.duration,
    this.onClose,
    this.onTap,
    this.managed = false,
  });

  @override
  State<_NToastOverlay> createState() => _NToastOverlayState();
}

class _NToastOverlayState extends State<_NToastOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  AnimationController? _progressController;
  Timer? _timer;
  DateTime? _timerStartedAt;
  Duration _remainingDuration = Duration.zero;
  double _dragOffset = 0;
  bool _dismissing = false;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    final yOffset = widget.position == NToastPosition.top ? -1.0 : 1.0;
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, yOffset),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    if (widget.duration > Duration.zero) {
      if (widget.progress) {
        _progressController = AnimationController(
          vsync: this,
          duration: widget.duration,
        );
        _progressController!.value = 1.0;
      }
      _scheduleDismiss(widget.duration);
    }
  }

  void _scheduleDismiss(Duration duration) {
    _remainingDuration = duration;
    _timerStartedAt = DateTime.now();
    _timer?.cancel();
    _timer = Timer(duration, _dismiss);
    _progressController?.animateTo(
      0,
      duration: duration,
      curve: Curves.linear,
    );
  }

  void _dismiss() {
    if (!mounted || _dismissing) return;
    _dismissing = true;
    _timer?.cancel();
    _progressController?.stop();
    _controller.reverse().then((_) {
      if (!mounted) return;
      widget.onClose?.call();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _progressController?.dispose();
    super.dispose();
  }

  void _pauseAutoDismiss() {
    if (!widget.pauseOnTouch ||
        widget.duration <= Duration.zero ||
        _paused ||
        _dismissing) {
      return;
    }

    _timer?.cancel();
    _progressController?.stop();

    final startedAt = _timerStartedAt;
    if (startedAt != null) {
      final elapsed = DateTime.now().difference(startedAt);
      _remainingDuration -= elapsed;
      if (_remainingDuration < Duration.zero) {
        _remainingDuration = Duration.zero;
      }
    }

    _paused = true;
  }

  void _resumeAutoDismiss() {
    if (!_paused || _dismissing) return;

    _paused = false;
    if (_remainingDuration <= Duration.zero) {
      _dismiss();
      return;
    }

    _scheduleDismiss(_remainingDuration);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_dismissing) return;
    setState(() {
      _dragOffset += details.delta.dy;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dismissing) return;

    const distanceThreshold = 80.0;
    const velocityThreshold = 700.0;
    final velocity = details.primaryVelocity ?? 0;

    if (_dragOffset.abs() > distanceThreshold ||
        velocity.abs() > velocityThreshold) {
      _dismiss();
    } else {
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final toast = NToast(
      title: widget.title,
      description: widget.description,
      icon: widget.icon,
      avatar: widget.avatar,
      actions: widget.actions,
      color: widget.color,
      position: widget.position,
      orientation: widget.orientation,
      closable: widget.closable,
      showIcon: widget.showIcon,
      progressAnimation: _progressController,
      onClose: _dismiss,
      onTap: widget.onTap,
    );

    Widget child = widget.dragToClose
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: _onDragUpdate,
            onVerticalDragEnd: _onDragEnd,
            child: Transform.translate(
              offset: Offset(0, _dragOffset),
              child: toast,
            ),
          )
        : toast;

    if (widget.pauseOnTouch) {
      child = Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _pauseAutoDismiss(),
        onPointerUp: (_) => _resumeAutoDismiss(),
        onPointerCancel: (_) => _resumeAutoDismiss(),
        child: child,
      );
    }

    final animated = SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          type: MaterialType.transparency,
          child: child,
        ),
      ),
    );

    // Managed toasts are positioned externally by NToaster's stack; only a
    // standalone (no-NToaster) toast anchors itself to the screen edge.
    if (widget.managed) return animated;

    return Positioned(
      bottom: widget.position == NToastPosition.bottom ? 24 : null,
      top: widget.position == NToastPosition.top ? topPadding + 24 : null,
      left: 16,
      right: 16,
      child: animated,
    );
  }
}
