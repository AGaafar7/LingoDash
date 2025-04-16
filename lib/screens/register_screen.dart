import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );
                final user = await authService.registerWithEmail(
                  _emailController.text,
                  _passwordController.text,
                  'user', // Default role
                );
                if (user != null) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/language-selection',
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration failed')),
                  );
                }
              },
              child: const Text('Register with Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );
                final user = await authService.registerWithGoogle();
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/language-selection');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Google Registration failed')),
                  );
                }
              },
              child: const Text('Register with Google'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            ElevatedButton(
              onPressed: () async {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );
                authService.registerWithPhone(
                  _phoneController.text,
                  (verificationId) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Verification code sent')),
                    );
                  },
                );
              },
              child: const Text('Register with Phone'),
            ),
          ],
        ),
      ),
    );
  }
}
