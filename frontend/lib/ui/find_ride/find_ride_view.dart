import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/ui/find_ride/ride_card.dart';

class FindRideView extends StatelessWidget {
  const FindRideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Ride')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'From',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_pin),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'To',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_searching),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Departure Time',
                          prefixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(),
                        ),
                        items:
                            ['Now', '15min', '30min', 'Select']
                                .map(
                                  (time) => DropdownMenuItem(
                                    value: time,
                                    child: Text(time),
                                  ),
                                )
                                .toList(),
                        value: "Now",
                        onChanged: (value) {
                          // Handle departure time selection
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Arrival Time',
                          prefixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(),
                        ),
                        items:
                            ['Soonest', '30min', '1hr', 'Select']
                                .map(
                                  (time) => DropdownMenuItem(
                                    value: time,
                                    child: Text(time),
                                  ),
                                )
                                .toList(),
                        value: "Soonest",
                        onChanged: (value) {
                          // Handle arrival time selection
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: List.generate(10, (index) {
                return RideCard(ride: Ride());
              }),
            ),
          ),
        ],
      ),
    );
  }
}
