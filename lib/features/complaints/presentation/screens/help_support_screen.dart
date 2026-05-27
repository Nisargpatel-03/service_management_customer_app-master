import 'package:flutter/material.dart';

import '../../../../core/widgets/fade_in.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      appBar: AppBar(
        title: const Text("Help & Support"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ Header
            FadeInWidget(
              delay: 100,
              child: const Text(
                "How can we help you?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Contact Support Card
            FadeInWidget(
              delay: 200,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
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
                  children: [

                    const Text(
                      "Contact Support",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: const [
                        Icon(Icons.email, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          "support@complaintapp.com",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: const [
                        Icon(Icons.phone, color: Colors.green),
                        SizedBox(width: 10),
                        Text(
                          "+91 98765 43210",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [

                        // Email Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Email Support UI Only 😄"),
                                ),
                              );
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.blue.withOpacity(0.12),
                              ),
                              child: const Center(
                                child: Text(
                                  "Email Us",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Call Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Call Support UI Only 😄"),
                                ),
                              );
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.green.withOpacity(0.12),
                              ),
                              child: const Center(
                                child: Text(
                                  "Call Now",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ✅ FAQ Heading
            FadeInWidget(
              delay: 300,
              child: const Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ✅ FAQ List
            FadeInWidget(
              delay: 400,
              child: const FAQTile(
                question: "How do I raise a complaint?",
                answer:
                "Go to Home Screen and tap on 'Raise New Complaint'. Fill details and submit.",
              ),
            ),

            FadeInWidget(
              delay: 500,
              child: const FAQTile(
                question: "How can I track technician?",
                answer:
                "Open Complaint Details and tap on 'Track Tech' button.",
              ),
            ),

            FadeInWidget(
              delay: 600,
              child: const FAQTile(
                question: "Can I reschedule my complaint?",
                answer:
                "Yes, you can reschedule from Complaint Details screen.",
              ),
            ),

            FadeInWidget(
              delay: 700,
              child: const FAQTile(
                question: "How do I cancel a complaint?",
                answer:
                "Tap Cancel button inside Complaint Details screen and confirm.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ✅ FAQ Expandable Tile Widget
//
class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        children: [
          Text(
            answer,
            style: const TextStyle(
              color: Colors.grey,
              height: 1.4,
            ),
          )
        ],
      ),
    );
  }
}