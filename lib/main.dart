import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/data/local_storage.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await LocalStorage.init();
  await NotificationService.init();

  runApp(const ComplaintApp());
}

class ComplaintApp extends StatefulWidget {
  const ComplaintApp({super.key});

  @override
  State<ComplaintApp> createState() => _ComplaintAppState();
}

class _ComplaintAppState extends State<ComplaintApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Complaint Service App",
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
