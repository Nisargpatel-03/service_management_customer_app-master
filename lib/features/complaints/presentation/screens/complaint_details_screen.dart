import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_layout.dart';
import '../../data/models/complaint_model.dart';
import 'complaint_progress_screen.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final String complaintId;

  const ComplaintDetailsScreen({
    super.key,
    required this.complaintId,
  });

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(String currentUserName) async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final newMessage = ComplaintMessage(
        senderId: user.uid,
        senderName: currentUserName,
        message: _messageController.text.trim(),
        senderRole: 'user',
        time: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.complaintId)
          .update({
        'messages': FieldValue.arrayUnion([newMessage.toMap()]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('complaints').doc(widget.complaintId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (!snapshot.hasData || !snapshot.data!.exists) return const Scaffold(body: Center(child: Text("Complaint not found")));
        
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final complaint = ComplaintModel.fromMap(data, snapshot.data!.id);

        return AppLayout(
          title: "Complaint Details",
          showBack: true,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: "Details"),
                    Tab(text: "Chat with Admin"),
                  ],
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildDetailsTab(complaint),
                      _buildChatTab(complaint),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsTab(ComplaintModel complaint) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(colors: [Color(0xff1976D2), Color(0xff42A5F5)]),
          ),
          child: Text(complaint.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 25),
        _infoTile(Icons.pending_actions, "Status", complaint.status),
        _infoTile(Icons.calendar_today, "Date", DateFormat("dd MMM yyyy").format(complaint.date)),
        _infoTile(Icons.location_on, "Address", complaint.address),
        const SizedBox(height: 25),
        const Text("Complaint Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
          child: Text(complaint.description, style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4)),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ComplaintProgressScreen(complaint: complaint.toMap())));
          },
          child: const Text("View Complaint Timeline", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildChatTab(ComplaintModel complaint) {
    final user = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        Expanded(
          child: complaint.messages.isEmpty
            ? const Center(child: Text("No messages yet. Send a note to Admin."))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: complaint.messages.length,
                itemBuilder: (context, index) {
                  final m = complaint.messages[index];
                  final isMe = m.senderRole == 'user';
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                          bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(m.senderName, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isMe ? Colors.white70 : Colors.black54)),
                          const SizedBox(height: 4),
                          Text(m.message, style: TextStyle(color: isMe ? Colors.white : Colors.black87)),
                          const SizedBox(height: 4),
                          Text(DateFormat("hh:mm a").format(m.time), style: TextStyle(fontSize: 9, color: isMe ? Colors.white60 : Colors.grey[600])),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!))),
          child: Row(
            children: [
              Expanded(child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(hintText: "Type a reply...", border: InputBorder.none),
              )),
              IconButton(icon: const Icon(Icons.send, color: Colors.blue), onPressed: () => _sendMessage(complaint.customerName)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
