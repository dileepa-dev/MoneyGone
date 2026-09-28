import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:moneygone/app/routes/app_pages.dart';
import 'package:moneygone/app/theme/app_theme.dart';

import '../screens/auth/auth_check_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MoneyGone',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      // Check Firebase login state when the app starts.
      home: const AuthCheckScreen(),

      // Keep GetX routes for navigation after startup.
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,

      transitionDuration: const Duration(
        milliseconds: 250,
      ),
    );
  }
}