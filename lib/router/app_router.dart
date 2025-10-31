import 'package:auto_route/auto_route.dart';
import 'package:hiodoshi_ao/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // 歡迎頁面(初次載入 app 會顯示的頁面)
    AutoRoute(
      path: '/main',
      initial: true,
      page: MainTabsContainerRoute.page,
      children: [
        AutoRoute(
            path: 'home',
            page: HomePageRoute.page
        ),
        AutoRoute(
            path: 'word-browsing',
            page: WordBrowsingPageRoute.page
        ),
      ]
    ),

    // 註冊頁面
    // AutoRoute(
    //   path: '/sign-up',
    //   page: SignUpRoute.page,
    //   children: const [],
    // ),
  ];
}
