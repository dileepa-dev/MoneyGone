import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/auth_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller =
    Get.find<AuthController>();

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                    SizedBox(
                      height: isTablet ? 20 : 5,
                    ),

                    // Image
                    SizedBox(
                      height: isTablet ? 260 : 205,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/signup_illustration.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Text
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Create ',
                            style: TextStyle(
                              color:
                              AppTheme.primaryGreen,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'Account',
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

                    // Description
                    const Text(
                      'Fill your details to register with\nMoney Gone.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF9B9B9B),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 26),

                    // Form
                    AuthTextField(
                      controller:
                      controller.signupNameController,
                      label: 'Full Name',
                      hint: 'John Doe',
                      textInputAction:
                      TextInputAction.next,
                    ),

                    const SizedBox(height: 18),

                    AuthTextField(
                      controller:
                      controller.signupEmailController,
                      label: 'Email',
                      hint: 'example@gmail.com',
                      keyboardType:
                      TextInputType.emailAddress,
                      textInputAction:
                      TextInputAction.next,
                    ),

                    const SizedBox(height: 18),

                    Obx(
                          () => AuthTextField(
                        controller:
                        controller.signupPasswordController,
                        label: 'Password',
                        hint: 'Create a password',
                        obscureText: controller
                            .isSignupPasswordHidden.value,
                        textInputAction:
                        TextInputAction.done,
                        suffixIcon: IconButton(
                          onPressed: controller
                              .toggleSignupPasswordVisibility,
                          icon: Icon(
                            controller
                                .isSignupPasswordHidden
                                .value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Obx(
                          () => AuthTextField(
                      controller: controller.signupConfirmPasswordController,
                            label: 'Re-enter Password',
                            hint: 'Re-enter your password',
                            obscureText: controller.isSignupConfirmPasswordHidden.value,
                            textInputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              onPressed: controller.toggleSignupConfirmPasswordVisibility,
                              icon: Icon(
                                controller
                                    .isSignupConfirmPasswordHidden
                                    .value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                    ),

                    const SizedBox(height: 24),

                    // Sign up button
                    Obx(
                          () => AuthButton(
                        text: 'Sign Up',
                        isLoading:
                        controller.isSignupLoading.value,
                        onPressed: controller.signup,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
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
                              color:
                              AppTheme.primaryGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: size.height < 700 ? 20 : 35,
                    ),
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