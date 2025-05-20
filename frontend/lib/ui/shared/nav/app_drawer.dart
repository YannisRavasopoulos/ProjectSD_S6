import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 23, 143, 117)),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard), // Added rewards icon
            title: const Text('Rewards'), // Added rewards title
            onTap: () {
              Navigator.pushNamed(
                context,
                '/rewards',
              ); // Navigate to rewards view
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Find Ride'),
            onTap: () {
              Navigator.pushNamed(context, '/find_ride');
            },
          ),
        ],
      ),
    );
  }
}
