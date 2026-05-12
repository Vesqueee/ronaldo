import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth/sign_in_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App UI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SignInScreen(),
    );
  }
}
