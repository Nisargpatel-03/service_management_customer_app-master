import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/widgets/app_layout.dart';
import 'success_screen.dart';
import '../../../../core/theme/page_transition.dart';

class ComplaintPreviewScreen extends StatefulWidget {
  final String contact;
  final String address;
  final String details;

  final PlatformFile? billFile;
  final XFile? problemPhoto;
  final PlatformFile? supportingDoc;

  final DateTime? dateTime;

  const ComplaintPreviewScreen({
    super.key,
    this.contact = "",
    this.address = "",
    this.details = "",
    this.billFile,
    this.problemPhoto,
    this.supportingDoc,
    this.dateTime,
  });

  @override
  State<ComplaintPreviewScreen> createState() => _ComplaintPreviewScreenState();
}

class _ComplaintPreviewScreenState extends State<ComplaintPreviewScreen> {
  bool isLoading = false;

  Future<void> _submitComplaint() async {
    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must be logged in to submit")),
        );
        return;
      }

      // 1. Fetch User details for the Admin to see
      final userDoc = await FirebaseFirestore.instance
          .collection('users_id')
          .doc(user.uid)
          .get();
      
      final userName = userDoc.data()?['name'] ?? "Unknown User";
      final userEmail = userDoc.data()?['email'] ?? user.email;

      // 2. Prepare Data (Aligned with Admin and Model structure)
      final complaintData = {
        'userId': user.uid,
        'userName': userName,
        'userEmail': userEmail,
        'title': widget.details.length > 30 
            ? "${widget.details.substring(0, 27)}..." 
            : widget.details,
        'issue': widget.details, // Admin uses 'issue'
        'description': widget.details, // Admin uses 'description'
        'contact': widget.contact,
        'address': widget.address,
        'district': 'Default', // You might want to add a selector for this
        'complaintDate': widget.dateTime ?? DateTime.now(),
        'status': 'Pending',
        'priority': 'medium', // Default priority
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'billFileName': widget.billFile?.name,
        'photoFileName': widget.problemPhoto?.name,
        'docFileName': widget.supportingDoc?.name,
        'attachments': [], // To be populated with URLs after upload
        'messages': [], // Chat history
        'notes': [],
        'parts': [],
        'logs': [
          {
            'time': Timestamp.now(),
            'action': 'Complaint submitted by user',
            'by': userName,
          }
        ],
      };

      // 3. Save to Firestore
      await FirebaseFirestore.instance
          .collection('complaints')
          .add(complaintData);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          FadePageRoute(page: const SuccessScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Complaint Preview",
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            // ✅ Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xff0D47A1), Color(0xff1976D2)],
                ),
              ),
              child: const Text(
                "Preview Your Complaint",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Contact
            _infoTile(Icons.phone, "Contact Number",
                widget.contact.isEmpty ? "Not Provided" : widget.contact),

            // ✅ Address
            _infoTile(Icons.location_on, "Address",
                widget.address.isEmpty ? "Not Provided" : widget.address),

            // ✅ Details
            _infoTile(Icons.report_problem, "Problem Details",
                widget.details.isEmpty ? "Not Provided" : widget.details),

            // ✅ Date & Time
            _infoTile(
              Icons.calendar_today,
              "Complaint Date & Time",
              widget.dateTime == null
                  ? "Not Selected"
                  : DateFormat("dd MMM yyyy • hh:mm a")
                      .format(widget.dateTime!),
            ),

            const SizedBox(height: 20),

            // ✅ Files Section
            const Text(
              "Attached Documents",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _fileTile(
              title: "Electricity Bill",
              value: widget.billFile?.name ?? "Not Uploaded",
            ),

            _fileTile(
              title: "Problem Photo",
              value: widget.problemPhoto?.name ?? "Not Uploaded",
            ),

            _fileTile(
              title: "Supporting Document",
              value: widget.supportingDoc?.name ?? "Not Uploaded",
            ),

            const SizedBox(height: 30),

            // ✅ Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: isLoading ? null : _submitComplaint,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "SUBMIT COMPLAINT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Info Tile Widget
  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ File Tile Widget
  Widget _fileTile({required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_file, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$title: $value",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
