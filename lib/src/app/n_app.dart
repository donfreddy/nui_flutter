import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';
import '../theme/components/n_card_theme.dart';

/// A drop-in replacement for [MaterialApp] that wires the entire NUI design
/// system in one place.
///
/// Configure the palette, radius, typography, and per-component overrides here:
/// every `N*` widget reads the theme automatically with no additional setup.
///
/// Accepts **every** [MaterialApp] property and forwards them unchanged.
/// Migrate an existing app by replacing `MaterialApp` with `NApp`.
///
/// ## Minimal usage
///
/// ```dart
/// NApp(
///   colors: NColors.light(
///     roles: {
///       NColorRole.primary: NColorScale.orange,
///     },
///   ),
///   home: const HomeScreen(),
/// )
/// ```
///
/// ## With custom radius and typography
///
/// ```dart
/// NApp(
///   colors: myColors,
///   darkColors: myDarkColors,
///   radius: const NRadius(base: 12),
///   home: const HomeScreen(),
/// )
/// ```
///
/// ## Already using MaterialApp?
///
/// You can still use [NTheme] directly:
/// ```dart
/// MaterialApp(
///   theme: NTheme.lightTheme(colors: myColors),
///   darkTheme: NTheme.darkTheme(colors: myDarkColors),
/// )
/// ```
class NApp extends StatelessWidget {
  /// Creates an [NApp] backed by [MaterialApp] (imperative routing).
  const NApp({
    super.key,
    // ── NUI config ──────────────────────────────────────────────────────────
    this.colors,
    this.darkColors,
    this.radius = const NRadius(),
    this.textScale = 1.0,
    this.typography,
    this.buttonRadius,
    this.inputRadius,
    this.extensions = const [],
    // ── MaterialApp ──────────────────────────────────────────────────────────
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.onNavigationNotification,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
  })  : _router = false,
        routerConfig = null,
        routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        backButtonDispatcher = null;

  /// Creates an [NApp] backed by [MaterialApp.router] (declarative routing).
  ///
  /// Use this variant with `go_router`, `auto_route`, etc.
  const NApp.router({
    this.colors,
    this.darkColors,
    super.key,
    // ── NUI config ──────────────────────────────────────────────────────────
    this.radius = const NRadius(),
    this.textScale = 1.0,
    this.typography,
    this.buttonRadius,
    this.inputRadius,
    this.extensions = const [],
    // ── MaterialApp.router ───────────────────────────────────────────────────
    this.scaffoldMessengerKey,
    this.routerConfig,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.backButtonDispatcher,
    this.onNavigationNotification,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
  })  : _router = true,
        navigatorKey = null,
        home = null,
        routes = const <String, WidgetBuilder>{},
        initialRoute = null,
        onGenerateRoute = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        navigatorObservers = const <NavigatorObserver>[];

  // ── NUI design-system config ───────────────────────────────────────────────

  /// The NUI semantic colors for light mode.
  final NColors? colors;

  /// The NUI semantic colors for dark mode.
  final NColors? darkColors;

  /// The corner-radius scale. Defaults to `NRadius(base: 8)`.
  final NRadius radius;

  /// Global text scale multiplier applied to the entire typography scale.
  /// Defaults to `1.0`.
  final double textScale;

  /// Optional custom typography. When `null`, the system default font is used.
  final NTypography? typography;

  /// Override the default button corner radius. Falls back to [radius.md].
  final double? buttonRadius;

  /// Override the default input corner radius. Falls back to [radius.md].
  final double? inputRadius;

  /// Additional [ThemeExtension]s merged into the generated [ThemeData].
  /// App-supplied extensions replace defaults when they share the same type.
  final Iterable<ThemeExtension<dynamic>> extensions;

  final bool _router;

  // ── MaterialApp / MaterialApp.router pass-through ─────────────────────────
  /// See [MaterialApp.navigatorKey].
  final GlobalKey<NavigatorState>? navigatorKey;

  /// See [MaterialApp.scaffoldMessengerKey].
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// See [MaterialApp.home].
  final Widget? home;

  /// See [MaterialApp.routes].
  final Map<String, WidgetBuilder> routes;

  /// See [MaterialApp.initialRoute].
  final String? initialRoute;

  /// See [MaterialApp.onGenerateRoute].
  final RouteFactory? onGenerateRoute;

  /// See [MaterialApp.onGenerateInitialRoutes].
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// See [MaterialApp.onUnknownRoute].
  final RouteFactory? onUnknownRoute;

  /// See [MaterialApp.onNavigationNotification].
  final NotificationListenerCallback<NavigationNotification>?
      onNavigationNotification;

  /// See [MaterialApp.navigatorObservers].
  final List<NavigatorObserver> navigatorObservers;

  /// See [MaterialApp.routerConfig].
  final RouterConfig<Object>? routerConfig;

  /// See [MaterialApp.router].
  final RouteInformationProvider? routeInformationProvider;

  /// See [MaterialApp.router].
  final RouteInformationParser<Object>? routeInformationParser;

  /// See [MaterialApp.router].
  final RouterDelegate<Object>? routerDelegate;

  /// See [MaterialApp.router].
  final BackButtonDispatcher? backButtonDispatcher;

  /// See [MaterialApp.builder].
  final TransitionBuilder? builder;

  /// See [MaterialApp.title].
  final String title;

  /// See [MaterialApp.onGenerateTitle].
  final GenerateAppTitle? onGenerateTitle;

  /// See [MaterialApp.color].
  final Color? color;

  /// Override the generated light [ThemeData]. When provided, the NUI
  /// extensions are merged in but the rest of the theme is respected.
  final ThemeData? theme;

  /// Override the generated dark [ThemeData].
  final ThemeData? darkTheme;

  /// See [MaterialApp.highContrastTheme].
  final ThemeData? highContrastTheme;

  /// See [MaterialApp.highContrastDarkTheme].
  final ThemeData? highContrastDarkTheme;

  /// See [MaterialApp.themeMode].
  final ThemeMode themeMode;

  /// See [MaterialApp.themeAnimationDuration].
  final Duration themeAnimationDuration;

  /// See [MaterialApp.themeAnimationCurve].
  final Curve themeAnimationCurve;

  /// See [MaterialApp.locale].
  final Locale? locale;

  /// See [MaterialApp.localizationsDelegates].
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// See [MaterialApp.localeListResolutionCallback].
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// See [MaterialApp.localeResolutionCallback].
  final LocaleResolutionCallback? localeResolutionCallback;

  /// See [MaterialApp.supportedLocales].
  final Iterable<Locale> supportedLocales;

  /// See [MaterialApp.debugShowMaterialGrid].
  final bool debugShowMaterialGrid;

  /// See [MaterialApp.showPerformanceOverlay].
  final bool showPerformanceOverlay;

  /// See [MaterialApp.checkerboardRasterCacheImages].
  final bool checkerboardRasterCacheImages;

  /// See [MaterialApp.checkerboardOffscreenLayers].
  final bool checkerboardOffscreenLayers;

  /// See [MaterialApp.showSemanticsDebugger].
  final bool showSemanticsDebugger;

  /// See [MaterialApp.debugShowCheckedModeBanner].
  final bool debugShowCheckedModeBanner;

  /// See [MaterialApp.shortcuts].
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// See [MaterialApp.actions].
  final Map<Type, Action<Intent>>? actions;

  /// See [MaterialApp.restorationScopeId].
  final String? restorationScopeId;

  /// See [MaterialApp.scrollBehavior].
  final ScrollBehavior? scrollBehavior;

  // ---------------------------------------------------------------------------
  // Internal theme builder
  // ---------------------------------------------------------------------------

  ThemeData _buildTheme(NColors c, Brightness brightness) {
    if (brightness == Brightness.light) {
      return NTheme.lightTheme(
        colors: c,
        radius: radius.base,
        textScale: textScale,
        typography: typography,
        extensions: extensions,
      );
    } else {
      return NTheme.darkTheme(
        colors: c,
        radius: radius.base,
        textScale: textScale,
        typography: typography,
        extensions: extensions,
      );
    }
  }

  ThemeData _mergeExtensions(ThemeData base, NColors c, Brightness b) {
    final bRadius = buttonRadius ?? radius.md;
    final iRadius = inputRadius ?? radius.md;
    final nuiExtensions = <ThemeExtension<dynamic>>[
      c,
      radius,
      b == Brightness.dark ? NShadows.dark() : NShadows.light(),
      NButtonTheme(radius: bRadius),
      NInputTheme(radius: iRadius),
      const NCardTheme(),
      if (typography != null) typography!,
      ...extensions,
    ];
    final merged = {
      for (final e in base.extensions.values) e.runtimeType: e,
      for (final e in nuiExtensions) e.runtimeType: e,
    }.values.toList();
    return base.copyWith(extensions: merged);
  }

  @override
  Widget build(BuildContext context) {
    final lightColors = colors ?? NColors.light();
    final darkColors = this.darkColors ?? colors ?? NColors.dark();

    final lightData = theme != null
        ? _mergeExtensions(theme!, lightColors, Brightness.light)
        : _buildTheme(lightColors, Brightness.light);
    final darkData = darkTheme != null
        ? _mergeExtensions(darkTheme!, darkColors, Brightness.dark)
        : _buildTheme(darkColors, Brightness.dark);

    if (_router) {
      return MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        routerConfig: routerConfig,
        routeInformationProvider: routeInformationProvider,
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate,
        backButtonDispatcher: backButtonDispatcher,
        onNavigationNotification: onNavigationNotification,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        theme: lightData,
        darkTheme: darkData,
        themeMode: themeMode,
        themeAnimationDuration: themeAnimationDuration,
        themeAnimationCurve: themeAnimationCurve,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        debugShowMaterialGrid: debugShowMaterialGrid,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
        scrollBehavior: scrollBehavior,
      );
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: home,
      routes: routes,
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      onNavigationNotification: onNavigationNotification,
      navigatorObservers: navigatorObservers,
      builder: builder,
      title: title,
      onGenerateTitle: onGenerateTitle,
      color: color,
      theme: lightData,
      darkTheme: darkData,
      themeMode: themeMode,
      themeAnimationDuration: themeAnimationDuration,
      themeAnimationCurve: themeAnimationCurve,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      debugShowMaterialGrid: debugShowMaterialGrid,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
      scrollBehavior: scrollBehavior,
    );
  }
}
