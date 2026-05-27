import 'package:flutter/material.dart';
import '../../../../core/navigation/main_navigation.dart';
import '../../../../core/theme/page_transition.dart';
import '../../../../core/widgets/fade_in.dart';
import 'complaint_details_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // ✅ Success Icon
              FadeInWidget(
                delay: 100,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.15),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 95,
                    color: Colors.green,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ✅ Title
              FadeInWidget(
                delay: 200,
                child: const Text(
                  "Complaint Submitted!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ✅ Subtitle
              FadeInWidget(
                delay: 300,
                child: const Text(
                  "Your complaint has been successfully registered.\nOur technician will contact you soon.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ✅ Back Home Button
              FadeInWidget(
                delay: 400,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      FadePageRoute(
                        page: const MainNavigation(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
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
                        "BACK TO HOME",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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
    );
  }
}