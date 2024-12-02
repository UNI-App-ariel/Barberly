import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_shop/owner_shop_bloc.dart';
import 'package:uni_app/features/owner/presentation/pages/home/owner_home_page.dart';
import 'package:uni_app/features/owner/presentation/pages/shop/owner_shop_page.dart';
import 'package:uni_app/features/profile/presentation/pages/profile_page.dart';

class OwnerNavigationBar extends StatefulWidget {
  const OwnerNavigationBar({super.key});

  @override
  State<OwnerNavigationBar> createState() => _OwnerNavigationBarState();
}

class _OwnerNavigationBarState extends State<OwnerNavigationBar> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const OwnerHomePage(),
      const OwnerShopPage(),
      const ProfilePage(),
    ];

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
          padding: const EdgeInsets.symmetric(horizontal: 50),
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
                icon: FontAwesomeIcons.shop,
                iconColor: Theme.of(context).colorScheme.inverseSurface,
                iconSize: 18,
                text: 'Shop',
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
    // get user
    final user = context.read<AuthBloc>().currentUser;

    if (user == null) {
      return;
    }

    if (user.shopId != null) {
      // get shop
      context.read<OwnerShopBloc>().add(GetShopEvent(user.shopId!));
    }
  }
}
