import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_app/core/common/statemangment/cubit/theme_cubit.dart';
import 'package:uni_app/core/common/widgets/my_button.dart';
import 'package:uni_app/core/common/widgets/my_list_tile.dart';
import 'package:uni_app/core/common/widgets/settings_list_container.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // profile picture
                const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),

                // name
                const Text(
                  'John Doe',
                  style: TextStyle(fontSize: 20),
                ),

                // email
                Text(
                  'example@gmail.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),

                const SizedBox(height: 20),

                // edit profile button
                MyButton(
                  borderRadius: 30,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                  onPressed: () {},
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // preferences container
                // title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // container
                SettingsListContainer(
                  tiles: [
                    MySettingsTile(
                      title: 'Settings',
                      leading: const FaIcon(
                        FontAwesomeIcons.gear,
                        size: 18,
                      ),
                      trailing: const Icon(
                        CupertinoIcons.chevron_right,
                        size: 20,
                      ),
                      onTap: () {},
                    ),
                    MySettingsTile(
                      title: 'Dark Mode',
                      leading: const FaIcon(
                        FontAwesomeIcons.moon,
                        size: 18,
                      ),
                      trailing: Switch.adaptive(
                        value: Theme.of(context).brightness == Brightness.dark,
                        onChanged: (value) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                      ),
                    ),
                    MySettingsTile(
                      title: 'Logout',
                      titleColor: Colors.red,
                      leadingBackgroundColor: Colors.red,
                      leading: const FaIcon(
                        FontAwesomeIcons.rightFromBracket,
                        color: Colors.white,
                        size: 18,
                      ),
                      onTap: () {
                        // logout
                        context.read<AuthBloc>().add(AuthLogOut());
                      },
                    ),
                  ],
                  dividerIndent: 60, // Customize indent if needed
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
