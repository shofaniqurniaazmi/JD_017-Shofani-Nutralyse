// Navigation Menu with Bottom Navigation Bar
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationMenu extends StatefulWidget {
  final Widget child; // Child widget passed by ShellRoute
  const NavigationMenu({Key? key, required this.child}) : super(key: key);

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Use GoRouter to navigate to the corresponding route
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/camera');
          break;
        case 2:
          context.go('/profile');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child, // Display the routed screen
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.grey[50],
        style: TabStyle.fixedCircle,
        activeColor: Colors.lime[600],
        color: Colors.grey.withOpacity(0.8),
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.camera, title: 'Camera'),
          TabItem(icon: Icons.account_circle, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}