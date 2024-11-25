import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        
      ),
      body: Center(
        child: user != null && user.name.isNotEmpty
            ? Text('Welcome ${user.name}')
            : const SizedBox.shrink(),
      ),
    );
  }
}
