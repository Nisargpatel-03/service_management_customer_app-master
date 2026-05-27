import 'package:flutter/material.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      body: Column(
        children: [

          // ===================================================
          // ✅ Gradient Profile Header
          // ===================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 50),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff0D47A1), Color(0xff1976D2)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: const [

                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.blue),
                ),

                SizedBox(height: 12),

                Text(
                  "Nisarg Patel",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "nisarg@gmail.com",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ===================================================
          // ✅ Complaint Stats Row
          // ===================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [

                ProfileStatCard(
                  title: "Total",
                  value: "12",
                  icon: Icons.receipt_long,
                  color: Colors.blue,
                ),

                ProfileStatCard(
                  title: "Pending",
                  value: "3",
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                ),

                ProfileStatCard(
                  title: "Completed",
                  value: "9",
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ===================================================
          // ✅ Profile Options List
          // ===================================================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [

                ProfileOptionTile(
                  icon: Icons.edit,
                  title: "Edit Profile",
                  subtitle: "Update your personal details",
                  onTap: () {},
                ),

                ProfileOptionTile(
                  icon: Icons.location_on,
                  title: "Saved Address",
                  subtitle: "Manage complaint service address",
                  onTap: () {},
                ),

                ProfileOptionTile(
                  icon: Icons.settings,
                  title: "Settings",
                  subtitle: "Notification & preferences",
                  onTap: () {},
                ),

                ProfileOptionTile(
                  icon: Icons.logout,
                  title: "Logout",
                  subtitle: "Sign out from your account",
                  isLogout: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// ✅ Profile Stat Card Widget
////////////////////////////////////////////////////////
class ProfileStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const ProfileStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [

          Icon(icon, color: color, size: 28),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// ✅ Profile Option Tile Widget
////////////////////////////////////////////////////////
class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLogout;
  final VoidCallback onTap;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          isLogout ? Colors.red.withOpacity(0.15) : Colors.blue.shade50,
          child: Icon(
            icon,
            color: isLogout ? Colors.red : Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLogout ? Colors.red : Colors.black,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}