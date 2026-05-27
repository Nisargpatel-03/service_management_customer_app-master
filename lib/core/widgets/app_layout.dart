import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showBack;

  const AppLayout({
    super.key,
    this.title,
    required this.child,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      // ✅ No AppBar — Custom Header
      body: SafeArea(
        child: Column(
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    if (showBack)
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),

                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // ✅ Screen Content
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}