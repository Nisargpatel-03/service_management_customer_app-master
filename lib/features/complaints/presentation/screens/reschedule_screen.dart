import 'package:flutter/material.dart';

class RescheduleScreen extends StatelessWidget {
  const RescheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      // AppBar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Reschedule Appointment",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ Complaint Info Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Washing Machine Repair",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Current Appointment: Today, 5:30 PM",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Select Date
            const Text(
              "Select New Date",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: const [
                  Icon(Icons.calendar_month, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Choose Date (UI Only)",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Select Time Slot
            const Text(
              "Select Time Slot",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                TimeSlotChip(text: "10 AM - 12 PM", active: true),
                TimeSlotChip(text: "12 PM - 2 PM"),
                TimeSlotChip(text: "2 PM - 4 PM"),
                TimeSlotChip(text: "4 PM - 6 PM"),
                TimeSlotChip(text: "6 PM - 8 PM"),
              ],
            ),

            const SizedBox(height: 25),

            // ✅ Reason Field
            const Text(
              "Reason (Optional)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write reason for rescheduling...",
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Confirm Button
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xff0D47A1), Color(0xff1976D2)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  "CONFIRM RESCHEDULE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

//
// ✅ Time Slot Chip Widget
//
class TimeSlotChip extends StatelessWidget {
  final String text;
  final bool active;

  const TimeSlotChip({
    super.key,
    required this.text,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: active ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}