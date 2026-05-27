import 'package:flutter/material.dart';
import '../../../../core/theme/page_transition.dart';
import '../../../../core/widgets/fade_in.dart';
import 'chat_screen.dart';

class TechnicianTrackingScreen extends StatelessWidget {
  const TechnicianTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      appBar: AppBar(
        title: const Text("Technician Tracking"),
      ),

      body: Column(
        children: [

          // ✅ Map Placeholder (Top)
          FadeInWidget(
            delay: 100,
            child: Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  Icon(
                    Icons.map,
                    size: 120,
                    color: Colors.white70,
                  ),
                  Positioned(
                    bottom: 20,
                    child: Text(
                      "Map Tracking Placeholder",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ✅ Technician Details Card
          FadeInWidget(
            delay: 250,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [

                  // Technician Avatar
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffE3F2FD),
                    child: Icon(
                      Icons.person,
                      size: 34,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Technician Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Technician: Raj Patel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Rating: ⭐ 4.8 | Experience: 5 yrs",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // Call Button
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.call, color: Colors.green),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ✅ Status + ETA Card
          FadeInWidget(
            delay: 350,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  Text(
                    "Live Status",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(Icons.directions_car, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Technician is on the way 🚗",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.timer, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Estimated Arrival: 15 Minutes",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ✅ Action Buttons (Chat + Back)
          FadeInWidget(
            delay: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [

                  // Chat Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          FadePageRoute(
                            page: const ChatScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [Color(0xff0D47A1), Color(0xff1976D2)],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "CHAT",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Back Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                          border: Border.all(color: Colors.blue),
                        ),
                        child: const Center(
                          child: Text(
                            "BACK",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}