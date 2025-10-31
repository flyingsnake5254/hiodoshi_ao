import 'package:hiodoshi_ao/locator.dart';
import 'package:hiodoshi_ao/router/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:global_configuration/global_configuration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  setupLocator();
  GetIt.instance.registerSingleton<AppRouter>(AppRouter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = GetIt.instance<AppRouter>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: GlobalConfiguration().getValue("environment") == 'development',
    );
  }
}