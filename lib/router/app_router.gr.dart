// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:hiodoshi_ao/router/custom_router/empty_router.dart' as _i1;
import 'package:hiodoshi_ao/ui/pages/example_view.dart' as _i2;
import 'package:hiodoshi_ao/ui/pages/home_page_view.dart' as _i3;
import 'package:hiodoshi_ao/ui/pages/main_tabs_container_view.dart' as _i4;
import 'package:hiodoshi_ao/ui/pages/practice_page_view.dart' as _i5;
import 'package:hiodoshi_ao/ui/pages/test_page_view.dart' as _i6;
import 'package:hiodoshi_ao/ui/pages/word_browsing_page/widgets/word_list_page.dart'
    as _i8;
import 'package:hiodoshi_ao/ui/pages/word_browsing_page/word_browsing_page_view.dart'
    as _i7;

/// generated route for
/// [_i1.EmptyRouterPage]
class EmptyRouter extends _i9.PageRouteInfo<void> {
  const EmptyRouter({List<_i9.PageRouteInfo>? children})
    : super(EmptyRouter.name, initialChildren: children);

  static const String name = 'EmptyRouter';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.EmptyRouterPage();
    },
  );
}

/// generated route for
/// [_i2.ExampleView]
class ExampleRoute extends _i9.PageRouteInfo<void> {
  const ExampleRoute({List<_i9.PageRouteInfo>? children})
    : super(ExampleRoute.name, initialChildren: children);

  static const String name = 'ExampleRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.ExampleView();
    },
  );
}

/// generated route for
/// [_i3.HomePageView]
class HomePageRoute extends _i9.PageRouteInfo<void> {
  const HomePageRoute({List<_i9.PageRouteInfo>? children})
    : super(HomePageRoute.name, initialChildren: children);

  static const String name = 'HomePageRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return _i3.HomePageView();
    },
  );
}

/// generated route for
/// [_i4.MainTabsContainerView]
class MainTabsContainerRoute extends _i9.PageRouteInfo<void> {
  const MainTabsContainerRoute({List<_i9.PageRouteInfo>? children})
    : super(MainTabsContainerRoute.name, initialChildren: children);

  static const String name = 'MainTabsContainerRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return _i4.MainTabsContainerView();
    },
  );
}

/// generated route for
/// [_i5.PracticePageView]
class PracticePageRoute extends _i9.PageRouteInfo<void> {
  const PracticePageRoute({List<_i9.PageRouteInfo>? children})
    : super(PracticePageRoute.name, initialChildren: children);

  static const String name = 'PracticePageRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return _i5.PracticePageView();
    },
  );
}

/// generated route for
/// [_i6.TestPageView]
class TestPageRoute extends _i9.PageRouteInfo<void> {
  const TestPageRoute({List<_i9.PageRouteInfo>? children})
    : super(TestPageRoute.name, initialChildren: children);

  static const String name = 'TestPageRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return _i6.TestPageView();
    },
  );
}

/// generated route for
/// [_i7.WordBrowsingPageView]
class WordBrowsingPageRoute extends _i9.PageRouteInfo<void> {
  const WordBrowsingPageRoute({List<_i9.PageRouteInfo>? children})
    : super(WordBrowsingPageRoute.name, initialChildren: children);

  static const String name = 'WordBrowsingPageRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i7.WordBrowsingPageView();
    },
  );
}

/// generated route for
/// [_i8.WordListPageView]
class WordListPageRoute extends _i9.PageRouteInfo<WordListPageRouteArgs> {
  WordListPageRoute({required String date, List<_i9.PageRouteInfo>? children})
    : super(
        WordListPageRoute.name,
        args: WordListPageRouteArgs(date: date),
        rawPathParams: {'date': date},
        initialChildren: children,
      );

  static const String name = 'WordListPageRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WordListPageRouteArgs>(
        orElse: () => WordListPageRouteArgs(date: pathParams.getString('date')),
      );
      return _i8.WordListPageView(date: args.date);
    },
  );
}

class WordListPageRouteArgs {
  const WordListPageRouteArgs({required this.date});

  final String date;

  @override
  String toString() {
    return 'WordListPageRouteArgs{date: $date}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WordListPageRouteArgs) return false;
    return date == other.date;
  }

  @override
  int get hashCode => date.hashCode;
}
