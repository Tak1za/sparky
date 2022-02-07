import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparky_for_reddit/screens/home_screen.dart';
import 'package:sparky_for_reddit/screens/profile_screen.dart';

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navbarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home,
          size: 30,
        ),
        title: ("Home"),
        routeAndNavigatorSettings:
            const RouteAndNavigatorSettings(initialRoute: '/'),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.person,
          size: 30,
        ),
        title: ("Profile"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navbarItems(),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
