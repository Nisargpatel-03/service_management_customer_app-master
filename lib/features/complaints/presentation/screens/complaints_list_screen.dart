import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/theme/page_transition.dart';
import '../../data/models/complaint_model.dart';
import 'complaint_details_screen.dart';

class ComplaintsListScreen extends StatefulWidget {
  const ComplaintsListScreen({super.key});

  @override
  State<ComplaintsListScreen> createState() => _ComplaintsListScreenState();
}

class _ComplaintsListScreenState extends State<ComplaintsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = "All";
  String selectedSort = "Latest";

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text("Please Login")));

    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      appBar: AppBar(
        title: const Text("My Complaints", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _searchBar(),
            const SizedBox(height: 18),
            _filterChips(),
            const SizedBox(height: 18),
            _sortRow(),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('complaints')
                    .where('userId', isEqualTo: user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No complaints found 😅"));
                  }

                  var docs = snapshot.data!.docs;
                  
                  // Apply local filters
                  var complaints = docs.map((doc) => 
                    ComplaintModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)
                  ).toList();

                  // Search filter
                  if (_searchController.text.isNotEmpty) {
                    complaints = complaints.where((c) => 
                      c.title.toLowerCase().contains(_searchController.text.toLowerCase())
                    ).toList();
                  }

                  // Status filter
                  if (selectedFilter != "All") {
                    complaints = complaints.where((c) => c.status == selectedFilter).toList();
                  }

                  // Sorting
                  if (selectedSort == "Latest") {
                    complaints.sort((a, b) => b.date.compareTo(a.date));
                  } else {
                    complaints.sort((a, b) => a.date.compareTo(b.date));
                  }

                  return ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final c = complaints[index];
                      return ComplaintCard(
                        title: c.title,
                        status: c.status,
                        date: c.date,
                        color: _getStatusColor(c.status),
                        onTap: () {
                          Navigator.push(
                            context,
                            FadePageRoute(page: ComplaintDetailsScreen(complaintId: c.id)),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'completed': return Colors.green;
      case 'rejected': return Colors.red;
      case 'active': return Colors.blue;
      default: return Colors.grey;
    }
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() {}),
        decoration: const InputDecoration(border: InputBorder.none, hintText: "Search complaints...", prefixIcon: Icon(Icons.search)),
      ),
    );
  }

  Widget _filterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ["All", "Pending", "Active", "Completed", "Rejected"].map((label) => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ChoiceChip(
            label: Text(label),
            selected: selectedFilter == label,
            onSelected: (v) => setState(() => selectedFilter = label),
          ),
        )).toList(),
      ),
    );
  }

  Widget _sortRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton<String>(
          value: selectedSort,
          items: ["Latest", "Oldest"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => setState(() => selectedSort = v!),
        ),
      ],
    );
  }
}

class ComplaintCard extends StatelessWidget {
  final String title, status;
  final DateTime date;
  final Color color;
  final VoidCallback onTap;
  const ComplaintCard({super.key, required this.title, required this.status, required this.date, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(Icons.assignment, color: color)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("${date.day}/${date.month}/${date.year}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ])),
            Text(status, style: TextStyle(fontWeight: FontWeight.bold, color: color))
          ],
        ),
      ),
    );
  }
}
