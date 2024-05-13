import 'package:NESForGains/auth.dart';
import 'package:NESForGains/screens/home_screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:NESForGains/constants.dart';

class LoginScreen extends StatefulWidget {
  /* Ignorerar varningen */
  // ignore: use_super_parameters
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/moon-2048727_1280.jpg'),
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
                padding: EdgeInsets.all(8.0),
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
                  // ignore: avoid_print
                  print('Username: ${_usernameController.text}');
                  // ignore: avoid_print
                  print('Password: ${_passwordController.text}');
                  AuthProvider.of(context)
                      .login(_usernameController.text.toString());
                  // Navigator.pushNamed(context, '/homeScreen');
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
