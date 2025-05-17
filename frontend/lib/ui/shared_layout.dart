import 'package:flutter/material.dart';

class SharedLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final bool isIndexed;

  const SharedLayout({
    required this.body,
    required this.currentIndex,
    required this.isIndexed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loop App'),
        backgroundColor: const Color.fromARGB(255, 23, 143, 117),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 23, 143, 117),
              ),
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
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor:
            isIndexed ? const Color.fromARGB(255, 23, 143, 117) : Colors.grey,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            label: 'Rides',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/activities_view');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/rides_view');
          }
        },
      ),
    );
  }
}
