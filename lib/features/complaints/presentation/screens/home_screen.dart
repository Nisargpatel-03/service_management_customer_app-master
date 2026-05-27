import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/fade_in.dart';
import '../../../../core/theme/page_transition.dart';
import 'complaint_details_screen.dart';
import 'complaints_history_screen.dart';
import 'raise_complaint_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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
    final user = FirebaseAuth.instance.currentUser;

    return AppLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // ✅ Premium Header
            FadeInWidget(
              delay: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, $userName 👋",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0D47A1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "How can we help you today?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xffE3F2FD),
                    child: Icon(Icons.person, color: Colors.blue),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Status Overview Cards
            FadeInWidget(
              delay: 200,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('complaints')
                    .where('userId', isEqualTo: user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  int pending = 0;
                  int active = 0;
                  int completed = 0;

                  if (snapshot.hasData) {
                    for (var doc in snapshot.data!.docs) {
                      String status = (doc['status'] ?? "Open").toString().toLowerCase();
                      if (status == "pending" || status == "open") pending++;
                      if (status == "in progress" || status == "active") active++;
                      if (status == "completed" || status == "done") completed++;
                    }
                  }

                  return Row(
                    children: [
                      _statusCard("Pending", pending, Colors.orange),
                      const SizedBox(width: 12),
                      _statusCard("Active", active, Colors.blue),
                      const SizedBox(width: 12),
                      _statusCard("Done", completed, Colors.green),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Quick Action Card
            FadeInWidget(
              delay: 300,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff0D47A1), Color(0xff1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff0D47A1).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Facing an issue?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Report any problem and our technicians will resolve it quickly.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          FadePageRoute(page: const RaiseComplaintScreen()),
                        );
                      },
                      child: const Text(
                        "RAISE COMPLAINT",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 35),

            // ✅ Recent Complaints Header
            FadeInWidget(
              delay: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff263238),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        FadePageRoute(page: const ComplaintHistoryScreen()),
                      );
                    },
                    child: const Text("View All"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ✅ Limited Complaints List (Top 3 Only)
            FadeInWidget(
              delay: 500,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('complaints')
                    .where('userId', isEqualTo: user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: const Center(
                        child: Text(
                          "No recent activity found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs.toList();
                  docs.sort((a, b) {
                    Timestamp t1 = a['createdAt'] ?? Timestamp.now();
                    Timestamp t2 = b['createdAt'] ?? Timestamp.now();
                    return t2.compareTo(t1);
                  });

                  // Only show top 3 for clean UI
                  final recentDocs = docs.take(3).toList();

                  return Column(
                    children: recentDocs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      String dateStr = "Recently";
                      if (data['createdAt'] != null) {
                        dateStr = DateFormat("dd MMM").format((data['createdAt'] as Timestamp).toDate());
                      }
                      return _recentTile(doc.id, data['title'] ?? "Complaint", data['status'] ?? "Pending", dateStr);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentTile(String id, String title, String status, String date) {
    Color statusColor;
    IconData statusIcon;

    final normalizedStatus = status.toLowerCase();

    switch (normalizedStatus) {
      case "pending":
      case "open":
        statusColor = Colors.orange;
        statusIcon = Icons.access_time_rounded;
        break;
      case "in progress":
      case "active":
        statusColor = Colors.blue;
        statusIcon = Icons.sync;
        break;
      case "completed":
      case "done":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case "rejected":
        statusColor = Colors.red;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline_rounded;
    }
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ComplaintDetailsScreen(complaintId: id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
