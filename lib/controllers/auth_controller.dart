import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();
  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final forgotEmailController = TextEditingController();

  final RxBool isLoginPasswordHidden = true.obs;
  final RxBool isSignupPasswordHidden = true.obs;
  final isSignupConfirmPasswordHidden = true.obs;
  final RxBool isLoginLoading = false.obs;
  final RxBool isSignupLoading = false.obs;
  final RxBool isForgotLoading = false.obs;

  void toggleLoginPasswordVisibility() {
    isLoginPasswordHidden.value =
    !isLoginPasswordHidden.value;
  }

  void toggleSignupPasswordVisibility() {
    isSignupPasswordHidden.value =
    !isSignupPasswordHidden.value;
  }

  void toggleSignupConfirmPasswordVisibility() {
    isSignupConfirmPasswordHidden.value =
    !isSignupConfirmPasswordHidden.value;
  }

  // Login
  Future<void> login() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();

    if (email.isEmpty) {
      _showError('Please enter your email.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showError('Please enter a valid email address.');
      return;
    }

    if (password.isEmpty) {
      _showError('Please enter your password.');
      return;
    }

    try {
      isLoginLoading.value = true;

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.snackbar(
        'Success',
        'You have successfully signed in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );

      Get.offAllNamed(AppRoutes.dashBoard);
    } on FirebaseAuthException catch (e) {
      _showFirebaseError(e);
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoginLoading.value = false;
    }
  }

  // signup
  Future<void> signup() async {
    final name = signupNameController.text.trim();
    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text.trim();
    final confirmPassword = signupConfirmPasswordController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter your full name.');
      return;
    }

    if (email.isEmpty) {
      _showError('Please enter your email.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showError('Please enter a valid email address.');
      return;
    }

    if (password.isEmpty) {
      _showError('Please enter a password.');
      return;
    }

    if (password.length < 6) {
      _showError(
        'Password must contain at least 6 characters.',
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please re-enter your password',
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
      );
      return;
    }

    try {
      isSignupLoading.value = true;

      final credential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);

      final user = credential.user; if (user == null) {
        _showError('Unable to create your account.');
        return;
      }
      // Save name to Firebase Auth
      await user.updateDisplayName(name);
      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Account Created',
        'Your account has been created successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      Get.offAllNamed(AppRoutes.dashBoard);
    } on FirebaseAuthException catch (e) {
      _showFirebaseError(e);
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isSignupLoading.value = false;
    }
  }

  // Forgot password
  Future<void> resetPassword() async {
    final email = forgotEmailController.text.trim();

    if (email.isEmpty) {
      _showError('Please enter your email.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showError('Please enter a valid email address.');
      return;
    }

    try {
      isForgotLoading.value = true;

      await _auth.sendPasswordResetEmail(
        email: email,
      );

      Get.snackbar(
        'Email Sent',
        'Please check your email for the password reset link.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );

      // Get.offNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      _showFirebaseError(e);
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isForgotLoading.value = false;
    }
  }

  void goToSignup() {
    Get.toNamed(AppRoutes.signup);
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  void goToLogin() {
    Get.offNamed(AppRoutes.login);
  }

  // Email regex validation
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }

  // Firebase Error Handling
  void _showFirebaseError(
      FirebaseAuthException e,
      ) {
    String message;

    switch (e.code) {
      case 'invalid-email':
        message = 'The email address is invalid.';
        break;

      case 'user-not-found':
        message = 'No account exists with this email.';
        break;

      case 'wrong-password':
      case 'invalid-credential':
        message = 'Incorrect email or password.';
        break;

      case 'email-already-in-use':
        message = 'An account already exists with this email.';
        break;

      case 'weak-password':
        message = 'Please choose a stronger password.';
        break;

      case 'network-request-failed':
        message = 'Please check your internet connection.';
        break;

      case 'too-many-requests':
        message =
        'Too many attempts. Please try again later.';
        break;

      default:
        message =
            e.message ?? 'Authentication failed.';
    }

    _showError(message);
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signupNameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    forgotEmailController.dispose();
    super.onClose();
  }
}