import 'package:flutter/material.dart';
import 'package:uni_app/core/themes/light_theme.dart';
import 'package:uni_app/features/auth/presentation/pages/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniApp',
      theme: lightTheme,
      themeMode: ThemeMode.light,
      home: const LoginPage(),
    );
  }
}
