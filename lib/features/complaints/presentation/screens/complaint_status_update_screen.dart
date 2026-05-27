import 'package:flutter/material.dart';

class ComplaintStatusUpdateScreen extends StatefulWidget {
  const ComplaintStatusUpdateScreen({super.key});

  @override
  State<ComplaintStatusUpdateScreen> createState() =>
      _ComplaintStatusUpdateScreenState();
}

class _ComplaintStatusUpdateScreenState
    extends State<ComplaintStatusUpdateScreen> {
  // ✅ Status Options
  final List<String> statusOptions = [
    "Open",
    "In Progress",
    "Technician Assigned",
    "On The Way",
    "Completed",
    "Rejected",
  ];

  String selectedStatus = "Open";

  final TextEditingController remarksController = TextEditingController();

  // ✅ Save Update Action
  void _saveStatusUpdate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Status Updated to: $selectedStatus ✅"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      appBar: AppBar(
        title: const Text(
          "Update Complaint Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ Complaint Info Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Color(0xffE3F2FD),
                    child: Icon(Icons.report_problem, color: Colors.blue),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Washing Machine Repair",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Select Status
            const Text(
              "Select New Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                underline: const SizedBox(),
                items: statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Remarks Input
            const Text(
              "Remarks / Notes",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: remarksController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write technician/admin remarks...",
                ),
              ),
            ),

            const Spacer(),

            // ✅ Save Button
            GestureDetector(
              onTap: _saveStatusUpdate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xff0D47A1), Color(0xff1976D2)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "SAVE STATUS UPDATE",
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

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}