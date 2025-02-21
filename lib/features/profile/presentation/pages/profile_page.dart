import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/common/widgets/my_button.dart';
import 'package:uni_app/core/common/widgets/my_list_tile.dart';
import 'package:uni_app/core/common/widgets/settings_list_container.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:uni_app/features/profile/presentation/pages/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppUserBloc>().currentUser;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // profile picture
                GestureDetector(
                  onTap: () {
                    if (user == null || user.photoUrl == null) return;
                    // show the image in a dialog
                    _showImageDialog(context, user);
                  },
                  child: Hero(
                    tag: 'profile_image',
                    transitionOnUserGestures: true,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user != null && user.photoUrl != null
                          ? CachedNetworkImageProvider(user.photoUrl!,
                              errorListener: (e) {
                              debugPrint('Error loading image: $e');
                            })
                          : null,
                      child: user == null || user.photoUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // name
                Text(
                  user?.name ?? '',
                  style: const TextStyle(fontSize: 20),
                ),

                // email
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),

                const SizedBox(height: 20),

                // edit profile button
                Visibility(
                  visible: user != null && user.accountType == 'email',
                  child: MyButton(
                    borderRadius: 30,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                    onPressed: () {
                      // Navigate to edit profile page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
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
                    // settings
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
                      onTap: () {
                        // Navigate to settings page
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),

                    // logout
                    MySettingsTile(
                      title: 'Logout',
                      titleColor: Colors.red,
                      leadingBackgroundColor: Colors.red,
                      leading: const FaIcon(
                        Icons.logout,
                        color: Colors.white,
                        size: 18,
                      ),
                      onTap: () {
                        // logout
                        MyUtils.showConfirmationDialog(
                          context: context,
                          title: 'Logout',
                          message: 'Are you sure you want to logout?',
                          onConfirm: () {
                            context.read<AuthBloc>().add(AuthLogOut());
                          },
                        );
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

  void _showImageDialog(BuildContext context, MyUser user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: CircleAvatar(
            radius: 100,
            backgroundImage: CachedNetworkImageProvider(user.photoUrl!),
          ),
        );
      },
    );
  }
}
