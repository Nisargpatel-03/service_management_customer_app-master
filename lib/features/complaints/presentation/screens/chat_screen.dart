import 'package:flutter/material.dart';
import '../../../../core/widgets/fade_in.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      // ✅ Chat AppBar
      appBar: AppBar(
        title: Row(
          children: const [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xffE3F2FD),
              child: Icon(Icons.person, color: Colors.blue),
            ),
            SizedBox(width: 10),
            Text(
              "Raj Patel",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.green),
            onPressed: () {},
          )
        ],
      ),

      body: Column(
        children: [

          // ✅ Chat Messages List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: const [

                FadeInWidget(
                  delay: 100,
                  child: ChatBubble(
                    message: "Hello! I’m on the way 🚗",
                    isSender: false,
                  ),
                ),

                FadeInWidget(
                  delay: 200,
                  child: ChatBubble(
                    message: "Okay great, please come soon.",
                    isSender: true,
                  ),
                ),

                FadeInWidget(
                  delay: 300,
                  child: ChatBubble(
                    message:
                    "Yes sir, ETA is about 15 minutes. Please keep the machine accessible.",
                    isSender: false,
                  ),
                ),

                FadeInWidget(
                  delay: 400,
                  child: ChatBubble(
                    message: "Sure, I will be ready 👍",
                    isSender: true,
                  ),
                ),
              ],
            ),
          ),

          // ✅ Input Box Area
          FadeInWidget(
            delay: 500,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: Row(
                children: [

                  // TextField
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Send Button
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Chat UI Only 😄"),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//
// ✅ Chat Bubble Widget
//
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
      isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isSender
              ? Colors.blue.withOpacity(0.15)
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isSender ? 18 : 0),
            bottomRight: Radius.circular(isSender ? 0 : 18),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}