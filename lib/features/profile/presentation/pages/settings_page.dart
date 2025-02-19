import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_app/core/common/statemangment/cubit/theme_cubit.dart';
import 'package:uni_app/core/common/widgets/my_list_tile.dart';
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
        return _buildAdminSettings();
      }
    }
    return const Center(
      child: Text(''),
    );
  }

  Widget _buildCustomerSettings() {
    return Column(
      children: [
        // const Center(child: Text('Customer settings')),
        _buildThemeSection(),
      ],
    );
  }

  Widget _buildOwnerSettings() {
    return Column(
      children: [
        // const Center(child: Text('Owner settings')),
        _buildThemeSection(),
      ],
    );
  }

  Widget _buildAdminSettings() {
    return Column(
      children: [
        const Center(child: Text('Admin settings')),
        _buildThemeSection(),
      ],
    );
  }

  Widget _buildThemeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header (Outside the Card)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Theme',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),

        // Grey Card for the Toggle Button
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: Theme.of(context).colorScheme.surface,
          elevation: 0, // No shadow for a flat design
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: _buildDarkModeToggle(),
        ),
      ],
    );
  }

  Widget _buildDarkModeToggle() {
    return MySettingsTile(
      title: 'Dark Mode',
      leading: const FaIcon(
        FontAwesomeIcons.solidMoon,
        size: 20, // Slightly larger icon
        color: Colors.blueGrey, // Custom icon color
      ),
      trailing: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add padding
        child: Switch.adaptive(
          value: context.watch<ThemeCubit>().state == ThemeMode.dark,
          onChanged: (value) {
            context.read<ThemeCubit>().toggleTheme();
          },
          activeColor: Colors.green, // Custom active color
          inactiveThumbColor: Colors.grey, // Custom inactive color
        ),
      ),
    );
  }
}
