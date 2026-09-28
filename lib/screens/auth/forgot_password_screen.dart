import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/auth_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller =
    Get.find<AuthController>();

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 80 : 28,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: isTablet ? 20 : 5,
                    ),

                    SizedBox(
                      height: isTablet ? 300 : 225,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/forgot_password_illustration.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 5),

                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Forgot ',
                            style: TextStyle(
                              color:
                              AppTheme.primaryGreen,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'Password?',
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

                    const Text(
                      'Enter your email to receive a password\n'
                          'reset link.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF9B9B9B),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 30),


                    AuthTextField(
                      controller:
                      controller.forgotEmailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType:
                      TextInputType.emailAddress,
                      textInputAction:
                      TextInputAction.done,
                    ),

                    const SizedBox(height: 28),

                    Obx(
                          () => AuthButton(
                        text: 'Reset Password',
                        isLoading:
                        controller.isForgotLoading.value,
                        onPressed:
                        controller.resetPassword,
                      ),
                    ),

                    SizedBox(
                      height: size.height < 700 ? 20 : 40,
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