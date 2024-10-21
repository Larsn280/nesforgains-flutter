import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/service/register_service.dart';
import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';
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
      logger.i(response);
      logger.i('Username: ${_emailController.text}');
      logger.i('Password: ${_passwordController.text}');
    } catch (e) {
      logger.w('Error creating user', error: e);
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
              style: AppConstants.headingStyle,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.white)),
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter you email',
                          filled: true,
                          fillColor: Colors.black54,
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
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            AppConstants.buildElevatedFunctionButton(
                context: context, onPressed: _createNewUser, text: 'Register'),
            AppConstants.buildElevatedFunctionButton(
                context: context,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Go back'),
          ],
        ),
      ),
    );
  }
}
