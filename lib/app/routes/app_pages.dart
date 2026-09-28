import 'package:get/get.dart';

import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../routes/app_routes.dart';
import '../../screens/dashboard/dashboard.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),

    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),

    GetPage(
      name: AppRoutes.dashBoard,
      page: () => const Dashboard(),
    ),
  ];
}