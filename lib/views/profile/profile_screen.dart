import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../app/themes.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppThemes.color1),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Header Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppThemes.color1, AppThemes.color2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.color1.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Avatar
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppThemes.color3,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppThemes.color1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // User Email
                  if (authController.currentUser?.email != null)
                    Text(
                      authController.currentUser!.email!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                  const SizedBox(height: 8),

                  Text(
                    'Homework Manager User',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Personal Information Section
            _buildSectionTitle('Personal Information'),
            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.email_outlined,
              title: 'Email Address',
              value: authController.currentUser?.email ?? 'Not available',
              color: AppThemes.color1,
            ),

            const SizedBox(height: 12),

            _buildInfoCard(
              icon: Icons.verified_user_outlined,
              title: 'Account Status',
              value: authController.currentUser?.emailVerified == true
                  ? 'Verified'
                  : 'Not Verified',
              color: AppThemes.color2,
            ),

            const SizedBox(height: 12),

            _buildInfoCard(
              icon: Icons.access_time_outlined,
              title: 'Member Since',
              value: authController.currentUser?.metadata.creationTime != null
                  ? _formatDate(
                      authController.currentUser!.metadata.creationTime!,
                    )
                  : 'Unknown',
              color: AppThemes.color4,
            ),

            const SizedBox(height: 32),

            // Settings Section
            _buildSectionTitle('Settings'),
            const SizedBox(height: 16),

            _buildSettingsOption(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              subtitle: 'Update your profile information',
              color: AppThemes.color1,
              onTap: () {
                Get.snackbar(
                  'Coming Soon',
                  'Profile editing will be available in the next update!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppThemes.color2,
                  colorText: Colors.black87,
                );
              },
            ),

            const SizedBox(height: 12),

            _buildSettingsOption(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              color: AppThemes.color2,
              onTap: () {
                Get.snackbar(
                  'Coming Soon',
                  'Notification settings will be available soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppThemes.color3,
                  colorText: Colors.black87,
                );
              },
            ),

            const SizedBox(height: 12),

            _buildSettingsOption(
              icon: Icons.security_outlined,
              title: 'Privacy & Security',
              subtitle: 'Manage your privacy settings',
              color: AppThemes.color4,
              onTap: () {
                Get.snackbar(
                  'Coming Soon',
                  'Privacy settings will be available soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppThemes.color4,
                  colorText: Colors.black87,
                );
              },
            ),

            const SizedBox(height: 12),

            _buildSettingsOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              color: AppThemes.color5,
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Text(
                      'Help & Support',
                      style: TextStyle(color: AppThemes.color1),
                    ),
                    content: const Text(
                      'For support, please contact us at:\n\n'
                      'Email: support@homeworkmanager.com\n'
                      'Phone: +1 (555) 123-4567\n\n'
                      'We\'re here to help you manage your homework better!',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'OK',
                          style: TextStyle(color: AppThemes.color1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _buildSettingsOption(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version and information',
              color: AppThemes.color3,
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Text(
                      'About Homework Manager',
                      style: TextStyle(color: AppThemes.color1),
                    ),
                    content: const Text(
                      'Homework Manager v1.0.0\n\n'
                      'A beautiful and effective app to help you manage your homework and assignments with ease.\n\n'
                      'Built with Flutter & Firebase\n'
                      'Designed with love ❤️',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'OK',
                          style: TextStyle(color: AppThemes.color1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Logout Button
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: AppThemes.color5,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.color5.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(color: AppThemes.color5),
                      ),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            authController.signOut();
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(color: AppThemes.color5),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppThemes.color1,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
