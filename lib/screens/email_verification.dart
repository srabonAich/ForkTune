import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final Color _primaryColor = const Color(0xFF7F56D9);
  bool _isResending = false;

  Future<void> _resendEmail() async {
    setState(() => _isResending = true);

    try {
      // Call the AuthService to resend the verification email
      await AuthService.forgotPassword(widget.email.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Reset link has been resent to your email'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Your Email'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Image
            Center(
              child: Image.asset(
                'assets/email_verification.png', // You'll need to add this asset
                height: 200,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            const Text(
              'Check Your Email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                children: [
                  const TextSpan(text: 'We sent a password reset link to '),
                  TextSpan(
                    text: widget.email,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const TextSpan(text: '. Please check your inbox and follow the instructions to reset your password.'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Didn't receive email section
            const Text(
              "Didn't receive the email?",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            // Check spam folder tip
            Text(
              "Check your spam folder or",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Resend button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isResending ? null : _resendEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isResending
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Resend Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Back to login button
            TextButton(
              onPressed: () {
                // Navigate back to login screen, removing all routes
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}