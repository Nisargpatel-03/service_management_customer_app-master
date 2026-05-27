import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/fade_in.dart';
import '../../../../core/theme/page_transition.dart';
import '../screens/complaint_details_screen.dart';

class ComplaintHistoryScreen extends StatefulWidget {
  const ComplaintHistoryScreen({super.key});

  @override
  State<ComplaintHistoryScreen> createState() => _ComplaintHistoryScreenState();
}

class _ComplaintHistoryScreenState extends State<ComplaintHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return AppLayout(
      title: "Activity History",
      showBack: Navigator.canPop(context),
      child: Column(
        children: [
          // ✅ Premium Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
            child: FadeInWidget(
              delay: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search by title or details...",
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.blue),
                    suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() { _searchQuery = ""; });
                          },
                        )
                      : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ),

          // ✅ History List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('complaints')
                  .where('userId', isEqualTo: user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var docs = snapshot.data?.docs ?? [];
                
                // Manual Filter & Sort
                var filteredDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = (data['title'] ?? "").toString().toLowerCase();
                  final details = (data['details'] ?? "").toString().toLowerCase();
                  return title.contains(_searchQuery) || details.contains(_searchQuery);
                }).toList();

                filteredDocs.sort((a, b) {
                  Timestamp t1 = (a.data() as Map)['createdAt'] ?? (a.data() as Map)['complaintDate'] ?? Timestamp.now();
                  Timestamp t2 = (b.data() as Map)['createdAt'] ?? (b.data() as Map)['complaintDate'] ?? Timestamp.now();
                  return t2.compareTo(t1);
                });

                if (filteredDocs.isEmpty) {
                  return FadeInWidget(
                    delay: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty ? "No history yet" : "No matches found",
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    
                    DateTime? date;
                    if (data['createdAt'] != null) {
                      date = (data['createdAt'] as Timestamp).toDate();
                    } else if (data['complaintDate'] != null) {
                      date = (data['complaintDate'] as Timestamp).toDate();
                    }

                    return FadeInWidget(
                      delay: 100 + (index * 50), // Staggered animation
                      child: _historyItem(
                        id: doc.id,
                        title: data['title'] ?? "Complaint",
                        status: data['status'] ?? "Pending",
                        date: date != null ? DateFormat("dd MMM yyyy, hh:mm a").format(date) : "Recently",
                        details: data['details'] ?? "",
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyItem({
    required String id,
    required String title,
    required String status,
    required String date,
    required String details,
  }) {
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
          FadePageRoute(page: ComplaintDetailsScreen(complaintId: id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Status Indicator Bar
                Container(width: 6, color: statusColor),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xff263238),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(statusIcon, size: 12, color: statusColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          details,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_outlined, size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 4),
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              "Details",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 16, color: Colors.blue),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
