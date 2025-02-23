import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/booked_appointments/booked_appointments_bloc.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/customer/presentation/pages/home/home_page.dart';
import 'package:uni_app/features/customer/presentation/pages/favorites/favorites_page.dart';
import 'package:uni_app/features/customer/presentation/pages/appointments/appointments_page.dart';
import 'package:uni_app/features/profile/presentation/pages/profile_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  late MyUser? user;
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const FavoritesPage(),
      const AppointmentsPage(),
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
                icon: FontAwesomeIcons.heart,
                iconColor: Theme.of(context).colorScheme.inverseSurface,
                iconSize: 18,
                text: 'Favorites',
              ),
              GButton(
                key: const Key('appointments_tab'),
                icon: CupertinoIcons.calendar_today,
                iconColor: Theme.of(context).colorScheme.inverseSurface,
                iconSize: 20,
                text: 'Appointments',
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
    context.read<BookedAppointmentsBloc>().add(GetBookedAppointments(user!.id));
  }
}


// BottomNavigationBar(
//         elevation: 0,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         selectedItemColor: Theme.of(context).colorScheme.primary,
//         unselectedItemColor: Theme.of(context).colorScheme.tertiary,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Appointments',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),