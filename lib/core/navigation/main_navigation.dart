import 'package:flutter/material.dart';
import '../../features/complaints/presentation/screens/complaints_history_screen.dart';
import '../../features/complaints/presentation/screens/home_screen.dart';
import '../../features/complaints/presentation/screens/notifications_screen.dart';
import '../../features/complaints/presentation/screens/raise_complaint_screen.dart';
import '../../features/complaints/presentation/screens/settings_screen.dart';

import '../theme/page_transition.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ✅ Screens List (NO const)
    final List<Widget> screens = [
      const HomeScreen(),

      // ✅ History Tab (Now fetches own data)
      const ComplaintHistoryScreen(),

      const NotificationsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],

      // ✅ Floating Complaint Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            FadePageRoute(
              page: const RaiseComplaintScreen(),
            ),
          ).then((_) {
            // ✅ Refresh UI when returning
            setState(() {});
          });
        },
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              _navItem(
                icon: Icons.home,
                label: "Home",
                index: 0,
              ),

              // History
              _navItem(
                icon: Icons.history,
                label: "History",
                index: 1,
              ),

              const SizedBox(width: 40),

              // Notifications
              _navItem(
                icon: Icons.notifications,
                label: "Alerts",
                index: 2,
              ),

              // Settings
              _navItem(
                icon: Icons.settings,
                label: "Settings",
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Bottom Nav Item Widget
  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool active = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? Colors.blue : Colors.grey,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: active ? Colors.blue : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}