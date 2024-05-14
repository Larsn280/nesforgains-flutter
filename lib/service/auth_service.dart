import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthState extends ChangeNotifier {
  String username = '';

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login(String username) {
    this.username = username;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    username = '';
    _isLoggedIn = false;
    notifyListeners();
  }

  bool checkLoginStatus() {
    return _isLoggedIn;
  }
}

class AuthProvider extends StatelessWidget {
  final Widget child;

  AuthProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthState>(
      create: (_) => AuthState(),
      child: child,
    );
  }

  static AuthState of(BuildContext context) =>
      Provider.of<AuthState>(context, listen: false);
}
