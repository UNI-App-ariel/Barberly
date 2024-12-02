import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  MyUser? _user;

  @override
  void initState() {
    super.initState();

    // get uesr
    _user = context.read<AuthBloc>().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_user != null) {
      if (_user!.role == 'customer') {
        return _buildCustomerSettings();
      } else if (_user!.role == 'owner') {
        return _buildOwnerSettings();
      } else if (_user!.role == 'admin') {
        return const Center(
          child: Text('Admin settings'),
        );
      }
    }
    return const Center(
      child: Text(''),
    );
  }

  Widget _buildCustomerSettings() {
    return const Center(
      child: Text('Customer settings'),
    );
  }

  Widget _buildOwnerSettings() {
    return const Center(
      child: Text('Owner settings'),
    );
  }
}
