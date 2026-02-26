import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailController = TextEditingController();
  final AuthService authService = AuthService();

  String message = "";

  Future<void> handleSubmit() async {
    final success = await authService.forgotPassword(emailController.text);

    if (success) {
      setState(() {
        message = "OTP sent to your email.";
      });
    } else {
      setState(() {
        message = "Email not found.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handleSubmit,
                child: const Text("Send OTP"),
              ),
            ),

            const SizedBox(height: 10),

            Text(message),
          ],
        ),
      ),
    );
  }
}