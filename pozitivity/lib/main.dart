import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pozitivity/utils/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:pozitivity/screens/LoginScreen.dart';
import 'package:pozitivity/screens/OnboardingScreen.dart';
import 'package:pozitivity/utils/add_affirmations_to_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pozitivity',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: hasSeenOnboarding ? const LoginScreen() : const OnboardingScreen(),
    );
  }
}
