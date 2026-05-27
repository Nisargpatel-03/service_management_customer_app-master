import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../../main.dart';
import '../../features/complaints/presentation/screens/complaint_details_screen.dart';
import '../../core/theme/page_transition.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  
  static StreamSubscription<QuerySnapshot>? _statusSubscription;
  static final Map<String, String> _lastKnownStatus = {};

  static Future<void> init() async {
    // 1. Request Permission
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // 2. Initialize Local Notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) _handleNavigation(details.payload!);
      },
    );

    // 3. Create High Importance Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Updates',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 4. Handle Foreground FCM Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(
        id: message.hashCode,
        title: message.notification?.title ?? "New Update",
        body: message.notification?.body ?? "",
        payload: message.data['complaintId'],
      );
    });

    // 5. Setup Token Saving
    _setupTokenSaving();
  }

  static void _setupTokenSaving() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        String? token = await _messaging.getToken();
        if (token != null) {
          await FirebaseFirestore.instance.collection('users_id').doc(user.uid).update({
            'fcmToken': token,
            'lastTokenUpdate': FieldValue.serverTimestamp(),
          }).catchError((e) {
            if (kDebugMode) print("Token update skipped: User doc might not exist yet");
          });
        }
        // Start monitoring for status changes
        startStatusMonitoring(user.uid);
      } else {
        _statusSubscription?.cancel();
      }
    });
  }

  /// Monitors Firestore for status changes while app is running
  static void startStatusMonitoring(String userId) {
    _statusSubscription?.cancel();
    _statusSubscription = FirebaseFirestore.instance
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          final data = change.doc.data() as Map<String, dynamic>;
          final docId = change.doc.id;
          final String newStatus = data['status'] ?? "Pending";
          final String title = data['title'] ?? "Complaint";

          // Only notify if status actually changed
          if (_lastKnownStatus.containsKey(docId) && _lastKnownStatus[docId] != newStatus) {
            _showLocalNotification(
              id: docId.hashCode,
              title: "Complaint Status: $newStatus",
              body: "Your complaint '$title' has been updated to $newStatus.",
              payload: docId,
            );
          }
          _lastKnownStatus[docId] = newStatus;
        } else if (change.type == DocumentChangeType.added) {
          final data = change.doc.data() as Map<String, dynamic>;
          _lastKnownStatus[change.doc.id] = data['status'] ?? "Pending";
        }
      }
    });
  }

  static Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'Updates',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: payload,
    );
  }

  static Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) _handleMessage(initialMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static void _handleMessage(RemoteMessage message) {
    if (message.data.containsKey('complaintId')) {
      _handleNavigation(message.data['complaintId']);
    }
  }

  static void _handleNavigation(String complaintId) {
    navigatorKey.currentState?.push(
      FadePageRoute(page: ComplaintDetailsScreen(complaintId: complaintId)),
    );
  }

  static Future<void> updateToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? token = await _messaging.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('users_id').doc(user.uid).update({'fcmToken': token});
      }
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
