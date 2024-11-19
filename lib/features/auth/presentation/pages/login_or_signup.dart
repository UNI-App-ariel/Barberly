import 'package:flutter/material.dart';
import 'package:uni_app/features/auth/presentation/pages/login_page.dart';
import 'package:uni_app/features/auth/presentation/pages/signup_page.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool _isLogin = true;

  // toggle between login and signup
  void _toggle() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLogin) {
      return LoginPage(toggle: _toggle);
    } else {
      return SignUpPage(toggle: _toggle);
    }
  }
}
