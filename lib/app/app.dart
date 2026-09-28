import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:moneygone/app/routes/app_pages.dart';
import '../app/routes/app_routes.dart';
import 'package:moneygone/app/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MoneyGone',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialRoute: AppRoutes.login,

      getPages: AppPages.pages,

      defaultTransition: Transition.cupertino,

      transitionDuration: const Duration(
        milliseconds: 250,
      ),
    );
  }
}