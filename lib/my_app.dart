import 'package:flutter/material.dart';
import 'package:uni_app/core/themes/dark_theme.dart';
import 'package:uni_app/core/themes/light_theme.dart';
import 'package:uni_app/features/auth/presentation/pages/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniApp',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthGate(),
    );
  }
}
