import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class NotificationSender {
  /// REPLACE THIS with your FCM Server Key
  /// Get it from: Firebase Console -> Project Settings -> Cloud Messaging -> Server Key
  static const String _serverKey = 'YOUR_SERVER_KEY_HERE';

  static Future<void> sendPushNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'to': fcmToken,
          'notification': {
            'title': title,
            'body': body,
            'android_channel_id': 'high_importance_channel',
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
          'priority': 'high',
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) print('Notification sent successfully');
      } else {
        if (kDebugMode) print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) print('Error sending notification: $e');
    }
  }
}
