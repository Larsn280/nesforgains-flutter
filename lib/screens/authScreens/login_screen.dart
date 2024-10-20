import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:nes_for_gains/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:isar/isar.dart';

class LoginScreen extends StatefulWidget {
  final Isar isar;

  const LoginScreen({super.key, required this.isar});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginService loginService;

  @override
  void initState() {
    super.initState();
    loginService = LoginService(widget.isar);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    try {
      final response = await loginService.loginUser(
          _usernameController.text.toString(),
          _passwordController.text.toString());
      if (response.username != '') {
        // Håll koll på.
        if (mounted) {
          AuthProvider.of(context)
              .login(response.id, response.username.toString());
        }
      }
    } catch (e) {
      logger.e('Error logging in user', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.backgroundimage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login Screen',
              style: AppConstants.headingStyle,
            ),
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.white)),
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        key: const ValueKey('username'),
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextField(
                        key: const ValueKey('password'),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            AppConstants.buildElevatedFunctionButton(
                context: context, onPressed: _loginUser, text: 'Login'),
            AppConstants.buildElevatedButton(
                context: context, path: '/registerScreen', text: 'Register'),
          ],
        ),
      ),
    );
  }
}
