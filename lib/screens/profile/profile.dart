import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneygone/widgets/common/navigation.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/profile_controller.dart';
// import your AppRoutes file here if it isn't already imported

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        // Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // =========================
              // PROFILE ICON
              // =========================
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFEDE9FE),
                child: Icon(
                  Icons.person,
                  size: 55,
                  color: Color(0xFF8162FF),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // USER NAME
              // =========================
              Text(
                controller.name.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              // =========================
              // EMAIL
              // =========================
              Text(
                controller.email.value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 35),

              // =========================
              // ACCOUNT INFORMATION
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _ProfileItem(
                      icon: Icons.person_outline,
                      title: 'Full Name',
                      value: controller.name.value,
                    ),
                    const Divider(height: 30),
                    _ProfileItem(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: controller.email.value,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // LOGOUT BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onItemSelected: (index) {
          if (index == 0) {
            Get.offAllNamed(AppRoutes.dashBoard);
          } else if (index == 1) {
            Get.toNamed(AppRoutes.expenses);
          }
          // index 2 is this screen, so nothing to do
        },
      ),
    );
  }
}

// ======================================================
// PROFILE ITEM
// ======================================================

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF8162FF)),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}