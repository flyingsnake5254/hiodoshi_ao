// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:hiodoshi_ao/router/custom_router/empty_router.dart' as _i1;
import 'package:hiodoshi_ao/ui/pages/example_view.dart' as _i2;
import 'package:hiodoshi_ao/ui/pages/home_page_view.dart' as _i3;
import 'package:hiodoshi_ao/ui/pages/main_tabs_container_view.dart' as _i4;
import 'package:hiodoshi_ao/ui/pages/word_browsing_page_view.dart' as _i5;

/// generated route for
/// [_i1.EmptyRouterPage]
class EmptyRouter extends _i6.PageRouteInfo<void> {
  const EmptyRouter({List<_i6.PageRouteInfo>? children})
    : super(EmptyRouter.name, initialChildren: children);

  static const String name = 'EmptyRouter';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.EmptyRouterPage();
    },
  );
}

/// generated route for
/// [_i2.ExampleView]
class ExampleRoute extends _i6.PageRouteInfo<void> {
  const ExampleRoute({List<_i6.PageRouteInfo>? children})
    : super(ExampleRoute.name, initialChildren: children);

  static const String name = 'ExampleRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.ExampleView();
    },
  );
}

/// generated route for
/// [_i3.HomePageView]
class HomePageRoute extends _i6.PageRouteInfo<void> {
  const HomePageRoute({List<_i6.PageRouteInfo>? children})
    : super(HomePageRoute.name, initialChildren: children);

  static const String name = 'HomePageRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i3.HomePageView();
    },
  );
}

/// generated route for
/// [_i4.MainTabsContainerView]
class MainTabsContainerRoute extends _i6.PageRouteInfo<void> {
  const MainTabsContainerRoute({List<_i6.PageRouteInfo>? children})
    : super(MainTabsContainerRoute.name, initialChildren: children);

  static const String name = 'MainTabsContainerRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i4.MainTabsContainerView();
    },
  );
}

/// generated route for
/// [_i5.WordBrowsingPageView]
class WordBrowsingPageRoute extends _i6.PageRouteInfo<void> {
  const WordBrowsingPageRoute({List<_i6.PageRouteInfo>? children})
    : super(WordBrowsingPageRoute.name, initialChildren: children);

  static const String name = 'WordBrowsingPageRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.WordBrowsingPageView();
    },
  );
}
