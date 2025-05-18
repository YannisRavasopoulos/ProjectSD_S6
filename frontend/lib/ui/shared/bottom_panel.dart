import 'package:flutter/material.dart';

class BottomPanel extends StatelessWidget {
  BottomPanel({super.key, required this.routeName});

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
