import 'package:get/get.dart';
import 'package:moneygone/screens/auth/auth_check_screen.dart';
import 'package:moneygone/screens/profile/profile.dart';

import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/expenses/ExpensesScreen.dart';
import '../routes/app_routes.dart';
import '../../screens/dashboard/dashboard.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const AuthCheckScreen(),
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

    GetPage(
      name: AppRoutes.profile,
      page: () => const Profile(),
    ),

    GetPage(
      name: AppRoutes.expenses,
      page: () => ExpensesScreen(),
    ),
  ];
}