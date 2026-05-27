import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/app_layout.dart';

class ComplaintProgressScreen extends StatelessWidget {
  final Map complaint;

  const ComplaintProgressScreen({
    super.key,
    required this.complaint,
  });

  // ✅ Call Technician Function
  Future<void> callTechnician(String phone) async {
    final Uri uri = Uri(scheme: "tel", path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // ✅ Status Color Logic
  Color getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "In Progress":
        return Colors.blue;
      case "Completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = complaint["status"] ?? "Pending";

    final technicianName =
        complaint["technician"] ?? "Not Assigned Yet";

    final technicianPhone =
        complaint["technicianPhone"] ?? "";

    final eta = complaint["eta"] ?? "Not Available";

    final statusColor = getStatusColor(status);

    // ✅ Timeline Steps
    final steps = [
      {"title": "Complaint Raised", "done": true},
      {
        "title": "Pending Review",
        "done": status == "Pending" ||
            status == "In Progress" ||
            status == "Completed"
      },
      {
        "title": "Technician Assigned",
        "done": status == "In Progress" || status == "Completed"
      },
      {"title": "Completed", "done": status == "Completed"},
    ];

    return AppLayout(
      title: "Complaint Timeline",
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ Complaint Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    statusColor.withOpacity(0.9),
                    statusColor.withOpacity(0.6),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    complaint["title"] ?? "No Title",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Status: $status",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Technician Card + Call Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [

                  const Icon(
                    Icons.engineering,
                    color: Colors.blue,
                    size: 28,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          technicianName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          eta,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ✅ Call Button Only If Phone Exists
                  if (technicianPhone.isNotEmpty)
                    IconButton(
                      icon: const Icon(
                        Icons.call,
                        color: Colors.green,
                        size: 28,
                      ),
                      onPressed: () {
                        callTechnician(technicianPhone);
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Progress Timeline",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Timeline Steps List
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  final isLast = index == steps.length - 1;

                  return _timelineStep(
                    title: step["title"] as String,
                    isDone: step["done"] as bool,
                    showLine: !isLast,
                    activeColor: statusColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Timeline Step Widget
  Widget _timelineStep({
    required String title,
    required bool isDone,
    required bool showLine,
    required Color activeColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Indicator + Animated Line
        Column(
          children: [

            CircleAvatar(
              radius: 14,
              backgroundColor:
              isDone ? activeColor : Colors.grey.shade300,
              child: Icon(
                isDone ? Icons.check : Icons.circle,
                size: 16,
                color: Colors.white,
              ),
            ),

            if (showLine)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Container(
                    width: 3,
                    height: 55 * value,
                    decoration: BoxDecoration(
                      color: isDone
                          ? activeColor
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
          ],
        ),

        const SizedBox(width: 14),

        // Step Card
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                )
              ],
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDone ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}