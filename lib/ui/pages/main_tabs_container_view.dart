import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiodoshi_ao/router/app_router.gr.dart';
import 'package:hiodoshi_ao/ui/pages/base_view.dart';
import 'package:hiodoshi_ao/viewmodels/main_tabs_container_view_model.dart';

@RoutePage()
class MainTabsContainerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView(
        builder: (context, model, child) {
          return AutoTabsRouter(
            routes: [
              HomePageRoute(),
              WordBrowsingPageRoute(),
              PracticePageRoute(),
              TestPageRoute()
            ],
            builder: (context, child) {
              final tabsRouter = AutoTabsRouter.of(context);
              return Scaffold(
                body: child,
                bottomNavigationBar: NavigationBar(
                    selectedIndex: tabsRouter.activeIndex,
                    onDestinationSelected: tabsRouter.setActiveIndex,
                    destinations: [
                      NavigationDestination(
                          icon: Image.asset(
                            'assets/images/oumua.png',
                            width: 24,
                            height: 24,
                          ),
                          selectedIcon: Icon(Icons.home_filled),
                          label: '首頁'
                      ),
                      NavigationDestination(
                          icon: Icon(Icons.wordpress_outlined),
                          selectedIcon: Icon(Icons.wordpress),
                          label: '單字'
                      ),
                      NavigationDestination(
                          icon: Icon(Icons.pan_tool_alt_outlined),
                          selectedIcon: Icon(Icons.pan_tool_alt),
                          label: '練習'
                      ),
                      NavigationDestination(
                          icon: Icon(Icons.my_library_books_outlined),
                          selectedIcon: Icon(Icons.my_library_books),
                          label: '測驗'
                      ),
                    ],
                ),
              );
            },
          );
        },
        modelProvider: () => MainTabsContainerViewModel(),
    );
  }

}