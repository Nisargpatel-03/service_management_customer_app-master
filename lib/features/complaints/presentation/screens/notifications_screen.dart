import 'package:flutter/material.dart';
import '../../../../core/widgets/fade_in.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Dummy Complaint Notifications List
    final List<Map<String, String>> notifications = [
      {
        "title": "Complaint Raised Successfully",
        "message": "Your complaint has been submitted and is Pending review.",
        "time": "Just now",
      },
      {
        "title": "Technician Assigned",
        "message": "Amit Patel has been assigned to your complaint.",
        "time": "10 min ago",
      },
      {
        "title": "Complaint Completed ✅",
        "message": "Your complaint has been resolved successfully.",
        "time": "Yesterday",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 45),

            // ✅ Page Title
            const Text(
              "Notifications",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Notification List
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];

                  return FadeInWidget(
                    delay: 100 * index,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Icon Bubble
                          CircleAvatar(
                            radius: 22,
                            backgroundColor:
                            Colors.blue.withOpacity(0.12),
                            child: const Icon(
                              Icons.notifications,
                              color: Colors.blue,
                            ),
                          ),

                          const SizedBox(width: 14),

                          // ✅ Text Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"] ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item["message"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // ✅ Time
                                Text(
                                  item["time"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}