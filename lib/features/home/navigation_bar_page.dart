import 'package:flutter/material.dart';
import 'package:uni_app/features/home/home_page.dart';
import 'package:uni_app/features/auth/presentation/pages/favorites_page.dart';
import 'package:uni_app/features/auth/presentation/pages/appointments_page.dart';
import 'package:uni_app/features/auth/presentation/pages/profile_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ??
            theme.scaffoldBackgroundColor, // Dynamic background
        selectedItemColor:
            theme.bottomNavigationBarTheme.selectedItemColor ?? theme.primaryColor,
        unselectedItemColor:
            theme.bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}