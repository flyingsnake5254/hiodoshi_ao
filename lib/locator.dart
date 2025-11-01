import 'package:get_it/get_it.dart';
import 'package:hiodoshi_ao/core/services/api_service.dart';
import 'package:hiodoshi_ao/viewmodels/base_view_model.dart';
import 'package:hiodoshi_ao/viewmodels/global_view_model.dart';
import 'package:hiodoshi_ao/viewmodels/home_page_view_model.dart';
import 'package:hiodoshi_ao/viewmodels/main_tabs_container_view_model.dart';
import 'package:hiodoshi_ao/viewmodels/practice_page_view_model.dart';
import 'package:hiodoshi_ao/viewmodels/test_page_view_model.dart';
import 'package:hiodoshi_ao/viewmodels/word_browsing_page_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => BaseViewModel());
  locator.registerLazySingleton(() => GlobalViewModel());
  locator.registerLazySingleton(() => ApiService());

  locator.registerLazySingleton(() => HomePageViewModel());
  locator.registerLazySingleton(() => WordBrowsingPageViewModel());
  locator.registerLazySingleton(() => MainTabsContainerViewModel());
  locator.registerLazySingleton(() => PracticePageViewModel());
  locator.registerLazySingleton(() => TestPageViewModel());
}