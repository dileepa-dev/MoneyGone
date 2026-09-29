import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/auth_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  static const Color lightGreen = Color(0xFFE8F5E9);

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    final size = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      // Keeps the page fixed when the keyboard opens
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Obx(() {
            final themeController = Get.find<ThemeController>();

            return IconButton(
              onPressed: themeController.toggleTheme,
              icon: Icon(
                themeController.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 80 : 28,
                ),
                child: Column(
                  children: [
                    SizedBox(height: isTablet ? 20 : 4),

                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: isTablet ? 270 : 180,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/signup_illustration.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 10),

                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Create ',
                                  style: TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Account',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Fill your details to register with\nMoney Gone.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF9B9B9B),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: lightGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_add_alt_1_rounded,
                                  size: 16,
                                  color: AppTheme.primaryGreen,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Join MoneyGone',
                                  style: TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Form card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          AuthTextField(
                            controller: controller.signupNameController,
                            label: 'Full Name',
                            hint: 'John Doe',
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 16),

                          AuthTextField(
                            controller: controller.signupEmailController,
                            label: 'Email',
                            hint: 'example@gmail.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 16),

                          Obx(
                                () => AuthTextField(
                              controller: controller.signupPasswordController,
                              label: 'Password',
                              hint: 'Create a password',
                              obscureText:
                              controller.isSignupPasswordHidden.value,
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                onPressed:
                                controller.toggleSignupPasswordVisibility,
                                icon: Icon(
                                  controller.isSignupPasswordHidden.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Obx(
                                () => AuthTextField(
                              controller:
                              controller.signupConfirmPasswordController,
                              label: 'Re-enter Password',
                              hint: 'Re-enter your password',
                              obscureText:
                              controller.isSignupConfirmPasswordHidden.value,
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                onPressed: controller
                                    .toggleSignupConfirmPasswordVisibility,
                                icon: Icon(
                                  controller.isSignupConfirmPasswordHidden.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          // Sign up button
                          Obx(
                                () => AuthButton(
                              text: 'Sign Up',
                              isLoading: controller.isSignupLoading.value,
                              onPressed: controller.signup,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already Have Account? ',
                          style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.goToLogin,
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height < 700 ? 20 : 35),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}