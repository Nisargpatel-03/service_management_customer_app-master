import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/page_transition.dart';
import '../../../../core/widgets/fade_in.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../auth/presentation/screens/login_screen.dart';

import 'edit_profile_screen.dart';
import 'help_support_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String userName = "Loading...";
  String userEmail = "...";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() => userEmail = user.email ?? "");
      final doc = await FirebaseFirestore.instance
          .collection('users_id')
          .doc(user.uid)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          userName = doc.data()?['name'] ?? "User";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Settings",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // ✅ Profile Card
            FadeInWidget(
              delay: 100,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Color(0xffE3F2FD),
                      child: Icon(
                        Icons.person,
                        size: 38,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userEmail,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          FadePageRoute(
                            page: const EditProfileScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Settings Options
            FadeInWidget(
              delay: 200,
              child: SettingsTile(
                icon: Icons.person_outline,
                title: "Edit Profile",
                subtitle: "Update your personal details",
                onTap: () {
                  Navigator.push(
                    context,
                    FadePageRoute(
                      page: const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ),

            FadeInWidget(
              delay: 300,
              child: SettingsTile(
                icon: Icons.language,
                title: "Language",
                subtitle: "Choose app language",
                onTap: () {},
              ),
            ),

            FadeInWidget(
              delay: 400,
              child: SettingsTile(
                icon: Icons.history,
                title: "Service History",
                subtitle: "View all past complaints",
                onTap: () {},
              ),
            ),

            FadeInWidget(
              delay: 500,
              child: SettingsTile(
                icon: Icons.support_agent,
                title: "Help & Support",
                subtitle: "FAQs and contact support",
                onTap: () {
                  Navigator.push(
                    context,
                    FadePageRoute(
                      page: const HelpSupportScreen(),
                    ),
                  );
                },
              ),
            ),

            FadeInWidget(
              delay: 600,
              child: SettingsTile(
                icon: Icons.description_outlined,
                title: "Warranty Documents",
                subtitle: "View warranty and terms",
                onTap: () {},
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Logout Button
            FadeInWidget(
              delay: 700,
              child: GestureDetector(
                onTap: () async {
                  // Clear FCM token on logout (optional but recommended for security)
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('users_id')
                        .doc(user.uid)
                        .update({'fcmToken': FieldValue.delete()});
                  }

                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      FadePageRoute(page: const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.red.withOpacity(0.12),
                  ),
                  child: const Center(
                    child: Text(
                      "LOGOUT",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//
// ✅ Settings Tile Widget
//
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue.withOpacity(0.12),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}