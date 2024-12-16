import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/statemangment/cubit/theme_cubit.dart';
import 'package:uni_app/core/themes/dark_theme.dart';
import 'package:uni_app/core/themes/light_theme.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/features/auth/presentation/pages/auth_gate.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_appointments/owner_appointments_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeMode, ThemeMode>(
      selector: (state) => state,
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Barberly',
          theme: lightTheme, // Light theme
          darkTheme: darkTheme, // Dark theme
          themeMode: themeMode, // Controlled by ThemeCubit
          home: const AuthGate(),
        );
      },
    );
  }
}
