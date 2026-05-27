import 'dart:async';
import 'package:flutter/material.dart';

class ComplaintChatSupportScreen extends StatefulWidget {
  const ComplaintChatSupportScreen({super.key});

  @override
  State<ComplaintChatSupportScreen> createState() =>
      _ComplaintChatSupportScreenState();
}

class _ComplaintChatSupportScreenState
    extends State<ComplaintChatSupportScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool isSupportTyping = false;

  // ✅ Reply Mode Variables
  String? replyText;

  // ✅ Messages List
  final List<Map<String, dynamic>> messages = [
    {
      "text": "Hello 👋 I raised a complaint about my washing machine.",
      "isUser": true,
      "time": "10:30 AM",
      "status": "seen",
    },
    {
      "text": "Hi Nisarg 😊 Support team here! We are checking your request.",
      "isUser": false,
      "time": "10:31 AM",
    },
  ];

  // ===================================================
  // ✅ Send Message Function + Tick Simulation + Reply
  // ===================================================
  void _sendMessage() {
    String text = messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({
        "text": text,
        "isUser": true,
        "time": "Now",
        "status": "sent",
        "reply": replyText,
      });

      replyText = null;
      isSupportTyping = true;
    });

    messageController.clear();
    _scrollToBottom();

    // Delivered Tick after 1 sec
    Timer(const Duration(seconds: 1), () {
      setState(() {
        messages.last["status"] = "delivered";
      });
    });

    // Seen Tick + Support Reply after 2 sec
    Timer(const Duration(seconds: 2), () {
      setState(() {
        messages.last["status"] = "seen";
        isSupportTyping = false;

        messages.add({
          "text": "Thanks 😊 Technician will reach you soon!",
          "isUser": false,
          "time": "Now",
        });
      });

      _scrollToBottom();
    });
  }

  // ===================================================
  // ✅ Auto Scroll
  // ===================================================
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  // ===================================================
  // ✅ Swipe Reply Trigger
  // ===================================================
  void _onSwipeReply(String message) {
    setState(() {
      replyText = message;
    });
  }

  // ===================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      // ✅ CLEAN TECHNICIAN APPBAR (NO SEARCH OPTION)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xff1976D2),
              child: Icon(Icons.support_agent, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Raj Patel",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Online • Support Technician",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [

          // ===================================================
          // ✅ Technician Detail Card
          // ===================================================
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xff1976D2),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Support Technician",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Raj Patel • ⭐4.8 Rating",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ===================================================
          // ✅ Chat Messages List
          // ===================================================
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(18),
              itemCount: messages.length + (isSupportTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isSupportTyping && index == messages.length) {
                  return const TypingIndicatorBubble();
                }

                final msg = messages[index];

                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      _onSwipeReply(msg["text"]);
                    }
                  },
                  child: ChatBubble(
                    text: msg["text"],
                    time: msg["time"],
                    isUser: msg["isUser"],
                    status: msg["isUser"] ? msg["status"] : null,
                    reply: msg["reply"],
                  ),
                );
              },
            ),
          ),

          // ===================================================
          // ✅ Reply Preview Bar
          // ===================================================
          if (replyText != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Replying to: $replyText",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        replyText = null;
                      });
                    },
                    child: const Icon(Icons.close),
                  )
                ],
              ),
            ),

          const SizedBox(height: 8),

          // ===================================================
          // ✅ Input Box + Send Button
          // ===================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xff0D47A1), Color(0xff1976D2)],
                      ),
                    ),
                    child: const Icon(Icons.send,
                        color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// ✅ Chat Bubble Widget
////////////////////////////////////////////////////////
class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isUser;
  final String? status;
  final String? reply;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isUser,
    this.status,
    this.reply,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xff1976D2) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [

            if (reply != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  reply!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUser ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),

            Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: isUser ? Colors.white70 : Colors.grey,
                  ),
                ),

                if (isUser) ...[
                  const SizedBox(width: 6),
                  Icon(
                    status == "sent"
                        ? Icons.check
                        : Icons.done_all,
                    size: 16,
                    color: status == "seen"
                        ? Colors.lightBlueAccent
                        : Colors.white70,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// ✅ Typing Indicator Bubble
////////////////////////////////////////////////////////
class TypingIndicatorBubble extends StatelessWidget {
  const TypingIndicatorBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          "Support is typing...",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}