import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/auth_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller =
    Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            final horizontalPadding =
            isTablet ? 80.0 : 28.0;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: isTablet ? 30 : 10,
                      ),

                      // Image
                      SizedBox(
                        height: isTablet ? 300 : 220,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/login_illustration.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(
                        height: isTablet ? 20 : 10,
                      ),

                      // welcome
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Hello ',
                              style: TextStyle(
                                color: AppTheme.primaryGreen,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'Again!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Form section
                      const Text(
                        'Fill your details or continue with\nsocial media.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF9B9B9B),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 28),

                      AuthTextField(
                        controller:
                        controller.loginEmailController,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType:
                        TextInputType.emailAddress,
                        textInputAction:
                        TextInputAction.next,
                      ),

                      const SizedBox(height: 18),

                      Obx(
                            () => AuthTextField(
                          controller:
                          controller.loginPasswordController,
                          label: 'Password',
                          hint: 'Enter your password',
                          obscureText: controller
                              .isLoginPasswordHidden.value,
                          textInputAction:
                          TextInputAction.done,
                          suffixIcon: IconButton(
                            onPressed: controller
                                .toggleLoginPasswordVisibility,
                            icon: Icon(
                              controller
                                  .isLoginPasswordHidden
                                  .value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed:
                          controller.goToForgotPassword,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 8,
                            ),
                          ),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Sign in button
                      Obx(
                            () => AuthButton(
                          text: 'Sign In',
                          isLoading:
                          controller.isLoginLoading.value,
                          onPressed: controller.login,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Create account navigation
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          const Text(
                            'New User? ',
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 12,
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.goToSignup,
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                color:
                                AppTheme.primaryGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}