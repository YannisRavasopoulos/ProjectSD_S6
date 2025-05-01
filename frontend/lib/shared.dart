import 'package:flutter/material.dart';

class SharedLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const SharedLayout({
    required this.body,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loop App')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 23, 143, 117),
              ),
              child: Text('Menu', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Color.fromARGB(255, 23, 143, 117),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Activities',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/activities');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
