import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/products/product_screen.dart';

void main() {
  runApp(const MyApp());
}

// True when testing  // Reminder== Set to false before production release
const bool devMode = true;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',

      // This is the important line to switch routes based on devMode
      initialRoute: devMode ? "/products" : "/login",

      routes: {
        "/login": (context) => const LoginScreen(),
        "/signup": (context) => const SignupScreen(),
        "/forgot": (context) => const ForgotPasswordScreen(),
        "/products": (context) => const ProductScreen(),
      },
    );
  }
}