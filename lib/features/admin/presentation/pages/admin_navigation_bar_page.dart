import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/features/admin/presentation/pages/home/admin_home_page.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/profile/presentation/pages/profile_page.dart';

class AdminNavigationBarPage extends StatefulWidget {
  const AdminNavigationBarPage({super.key});

  @override
  State<AdminNavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<AdminNavigationBarPage> {
  late MyUser? user;
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const AdminHomePage(),
      const ProfilePage(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GNav(
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            gap: 8,
            activeColor: Theme.of(context).colorScheme.primary,
            tabActiveBorder: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            tabs: [
              GButton(
                icon: FontAwesomeIcons.house,
                iconColor: Theme.of(context).colorScheme.inverseSurface,
                iconSize: 18,
                text: 'Home',
              ),
              GButton(
                icon: FontAwesomeIcons.user,
                iconColor: Theme.of(context).colorScheme.inverseSurface,
                iconSize: 18,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initDependencies() {
    user = context.watch<AppUserBloc>().currentUser;
    if (user == null) {
      return;
    }
  }
}
