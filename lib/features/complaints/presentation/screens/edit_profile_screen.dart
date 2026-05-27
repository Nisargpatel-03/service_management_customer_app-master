import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/widgets/fade_in.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailController.text = user.email ?? "";
      final doc = await FirebaseFirestore.instance
          .collection('users_id')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        nameController.text = data['name'] ?? "";
        phoneController.text = data['phone'] ?? "";
        addressController.text = data['address'] ?? "";
      }
    }
  }

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users_id')
            .doc(user.uid)
            .update({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile Updated Successfully ✅")),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // ✅ Profile Avatar
            FadeInWidget(
              delay: 100,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(0xffE3F2FD),
                    child: Icon(
                      Icons.person,
                      size: 55,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Change Photo",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // ✅ Name Field
            FadeInWidget(
              delay: 200,
              child: _buildField(
                label: "Full Name",
                hint: "Enter your name",
                controller: nameController,
                icon: Icons.person_outline,
              ),
            ),
            const SizedBox(height: 15),

            // ✅ Email Field
            FadeInWidget(
              delay: 300,
              child: _buildField(
                label: "Email Address",
                hint: "Enter your email",
                controller: emailController,
                icon: Icons.email_outlined,
                readOnly: true,
              ),
            ),
            const SizedBox(height: 15),

            // ✅ Phone Field
            FadeInWidget(
              delay: 400,
              child: _buildField(
                label: "Phone Number",
                hint: "+91 XXXXX XXXXX",
                controller: phoneController,
                icon: Icons.phone_outlined,
              ),
            ),
            const SizedBox(height: 15),

            // ✅ Address Field
            FadeInWidget(
              delay: 500,
              child: _buildField(
                label: "Address",
                hint: "Enter your address",
                controller: addressController,
                icon: Icons.location_on_outlined,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Save Button
            FadeInWidget(
              delay: 600,
              child: GestureDetector(
                onTap: isLoading ? null : _updateProfile,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xff0D47A1), Color(0xff1976D2)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "SAVE CHANGES",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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

  // ✅ Input Field Widget
  static Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hint,
            fillColor: readOnly ? Colors.grey[200] : Colors.white,
            filled: readOnly,
          ),
        ),
      ],
    );
  }
}
