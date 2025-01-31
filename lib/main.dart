import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sprints_firebase_task/screens/user_details_screen.dart';
import 'package:sprints_firebase_task/screens/input_form_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Info App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const InputFormScreen(),
      routes: {
        '/display': (context) => const UserDetailsScreen(),
      },
    );
  }
}
