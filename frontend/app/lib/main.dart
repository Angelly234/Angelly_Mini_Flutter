import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/products/product_screen.dart';
import 'screens/categories/category_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginScreen(),
        "/signup": (context) => const SignupScreen(),
        "/forgot": (context) => const ForgotPasswordScreen(),
        "/products": (context) => const ProductScreen(),
        "/categories": (context) => const CategoryScreen(),
      },
    );
  }
}