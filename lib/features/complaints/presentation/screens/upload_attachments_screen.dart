import 'package:flutter/material.dart';
import '../../../../core/widgets/fade_in.dart';

class UploadAttachmentsScreen extends StatelessWidget {
  const UploadAttachmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      appBar: AppBar(
        title: const Text("Upload Attachments"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ Complaint Info Card
            FadeInWidget(
              delay: 100,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Complaint: Washing Machine Repair",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Upload images/videos for better support.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Upload Box
            FadeInWidget(
              delay: 200,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Upload Feature UI Only 😄"),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.cloud_upload,
                          size: 60, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(
                        "Tap to Upload File",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Images / Videos / Documents",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Uploaded Files Heading
            FadeInWidget(
              delay: 300,
              child: const Text(
                "Uploaded Files",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ✅ File Preview Cards
            FadeInWidget(
              delay: 400,
              child: const UploadedFileCard(
                fileName: "washing_machine_issue.jpg",
                fileSize: "1.2 MB",
                icon: Icons.image,
                color: Colors.green,
              ),
            ),

            FadeInWidget(
              delay: 500,
              child: const UploadedFileCard(
                fileName: "repair_video.mp4",
                fileSize: "5.8 MB",
                icon: Icons.video_file,
                color: Colors.orange,
              ),
            ),

            FadeInWidget(
              delay: 600,
              child: const UploadedFileCard(
                fileName: "warranty_doc.pdf",
                fileSize: "650 KB",
                icon: Icons.picture_as_pdf,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Add More Button
            FadeInWidget(
              delay: 700,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Add More Files UI Only 😄"),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      "+ Add More Files",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Done Button
            FadeInWidget(
              delay: 800,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
                      "DONE",
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
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ✅ Uploaded File Card Widget
class UploadedFileCard extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final IconData icon;
  final Color color;

  const UploadedFileCard({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [

          // File Icon
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 14),

          // File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileSize,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Remove Icon (UI Only)
          Icon(Icons.close, color: Colors.red.withOpacity(0.7)),
        ],
      ),
    );
  }
}