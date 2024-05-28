import 'package:NESForGains/service/auth_service.dart';
import 'package:NESForGains/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:NESForGains/constants.dart';
import 'package:isar/isar.dart';

class LoginScreen extends StatefulWidget {
  final Isar isar;
  /* Ignorerar varningen */
  // ignore: use_super_parameters
  const LoginScreen({Key? key, required this.isar}) : super(key: key);

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

  //TODO Finns att fixa
  void _loginUser() async {
    try {
      final response = await loginService.loginUser(
          _usernameController.text.toString(),
          _passwordController.text.toString());
      if (response.username != '') {
        // Håll koll på.
        AuthProvider.of(context)
            .login(response.id, response.username.toString());
      }
    } catch (e) {
      print('Error logging in user: $e');
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
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppConstants.primaryTextColor, width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter your username',
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
                        hintText: 'Enter your password',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
                onPressed: () {
                  _loginUser();
                },
                child: const Text('Login')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/registerScreen');
                },
                child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
