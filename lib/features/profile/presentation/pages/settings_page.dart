import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_app/core/common/statemangment/cubit/theme_cubit.dart';
import 'package:uni_app/core/common/widgets/my_list_tile.dart';
import 'package:uni_app/core/common/widgets/settings_list_container.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SettingsListContainer(
            header: 'APP SETTINGS',
            tiles: [
              MySettingsTile(
                title: 'Dark Mode',
                leading: const Icon(
                  FontAwesomeIcons.solidMoon,
                  size: 18,
                  color: Colors.indigo,
                ),
                trailing: Switch.adaptive(
                  value: context.watch<ThemeCubit>().state == ThemeMode.dark,
                  onChanged: (value) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
