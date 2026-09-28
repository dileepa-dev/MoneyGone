import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User information
  final name = 'User'.obs;
  final email = ''.obs;

  // Loading state
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  // Load current logged user's information
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;

      if (user == null) {
        name.value = 'User';
        email.value = '';
        return;
      }

      // Email comes directly from Firebase Authentication
      email.value = user.email ?? '';

      // Name comes from Firestore
      final document = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (document.exists) {
        final data =
        document.data() as Map<String, dynamic>;

        name.value = data['name'] ?? user.displayName ?? 'User';

        // Use Firestore email if available
        email.value = data['email'] ?? user.email ?? '';
      } else {
        name.value =
        user.displayName ?? 'User';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load profile information.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    Get.dialog(
      const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      barrierDismissible: false,
    );

    try {
      await _auth.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        'Error',
        'Unable to logout. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}