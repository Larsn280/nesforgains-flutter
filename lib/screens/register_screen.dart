import 'package:NESForGains/service/register_service.dart';
import 'package:flutter/material.dart';
import 'package:NESForGains/constants.dart';
import 'package:isar/isar.dart';

class RegisterScreen extends StatefulWidget {
  final Isar isar;

  const RegisterScreen({super.key, required this.isar});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late RegisterService registerService;

  @override
  void initState() {
    super.initState();
    registerService = RegisterService(widget.isar);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _createNewUser() async {
    try {
      String response = await registerService.createNewUser(
          _emailController.text.toString(),
          _passwordController.text.toString());
      print(response);
      // ignore: avoid_print
      print('Username: ${_emailController.text}');
      // ignore: avoid_print
      print('Password: ${_passwordController.text}');
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstants.backgroundimage),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Register Screen',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter you email',
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter yout password',
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
                onPressed: () {
                  _createNewUser();
                },
                child: const Text('Register')),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Go back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
