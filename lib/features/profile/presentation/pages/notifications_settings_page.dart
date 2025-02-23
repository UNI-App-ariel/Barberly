import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/common/widgets/my_list_tile.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  late MyUser? user;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    user = context.watch<AppUserBloc>().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              MySettingsTile(
                title: 'Push Notifications',
                subtitle: Text(
                  'Receive new Appointment notifications, reminders, and more',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                ),
                leading: const Icon(
                  FontAwesomeIcons.solidBell,
                  size: 18,
                  color: Colors.red,
                ),
                trailing: Switch.adaptive(
                  value: true,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ));
  }
}
