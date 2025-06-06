import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  AppNavigationBar({super.key, required this.routeName});

  final String routeName;

  final List<String> _routes = ['/home', '/activities', '/profile'];

  void _onItemTapped(BuildContext context, int index) {
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _routes.indexOf(routeName),
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: const Color.fromARGB(255, 23, 143, 117),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded),
          label: 'Activities',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
