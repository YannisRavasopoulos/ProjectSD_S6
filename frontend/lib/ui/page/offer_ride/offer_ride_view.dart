import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/ui/page/offer_ride/offer_ride_viewmodel.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';

enum OfferRideMode { createdRides, activities }

class OfferRideView extends StatelessWidget {
  final OfferRideViewModel viewModel;
  final ActivitiesViewModel activitiesViewModel;

  const OfferRideView({
    Key? key,
    required this.viewModel,
    required this.activitiesViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Ride? newRide = ModalRoute.of(context)?.settings.arguments as Ride?;
    if (newRide != null &&
        !viewModel.createdRides.any((r) => r.id == newRide.id)) {
      viewModel.addRide(newRide);
    }

    final modeNotifier = ValueNotifier<OfferRideMode>(
      OfferRideMode.createdRides,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Ride'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: Column(
        children: [
          _OfferRideModeSelector(modeNotifier: modeNotifier),
          Expanded(
            child: ValueListenableBuilder<OfferRideMode>(
              valueListenable: modeNotifier,
              builder: (context, mode, _) {
                if (mode == OfferRideMode.createdRides) {
                  return CreatedRidesList(viewModel: viewModel);
                } else {
                  return ActivitiesList(
                    viewModel: activitiesViewModel,
                    fetchCarpoolers: viewModel.findNearbyCarpoolers,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferRideModeSelector extends StatelessWidget {
  final ValueNotifier<OfferRideMode> modeNotifier;

  const _OfferRideModeSelector({required this.modeNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<OfferRideMode>(
      valueListenable: modeNotifier,
      builder: (context, mode, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Created Rides'),
                selected: mode == OfferRideMode.createdRides,
                onSelected: (selected) {
                  if (selected) modeNotifier.value = OfferRideMode.createdRides;
                },
                selectedColor: Colors.teal,
                labelStyle: TextStyle(
                  color:
                      mode == OfferRideMode.createdRides
                          ? Colors.white
                          : Colors.teal,
                ),
              ),
              const SizedBox(width: 16),
              ChoiceChip(
                label: const Text('Activities'),
                selected: mode == OfferRideMode.activities,
                onSelected: (selected) {
                  if (selected) modeNotifier.value = OfferRideMode.activities;
                },
                selectedColor: Colors.teal,
                labelStyle: TextStyle(
                  color:
                      mode == OfferRideMode.activities
                          ? Colors.white
                          : Colors.teal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CreatedRidesList extends StatelessWidget {
  final OfferRideViewModel viewModel;

  const CreatedRidesList({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final rides = viewModel.createdRides;
        if (rides.isEmpty) {
          return const Center(
            child: Text(
              'No rides found.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: rides.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final ride = rides[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade200,
                  child: const Icon(Icons.directions_car, color: Colors.white),
                ),
                title: Text(
                  '${ride.from} → ${ride.to}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text('Ride ID: ${ride.id}'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.teal,
                ),
                onTap: () async {
                  final carpoolers = await viewModel.findNearbyCarpoolers(
                    ride.id.toString(),
                  );
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text('Nearby Carpoolers'),
                          content:
                              carpoolers.isEmpty
                                  ? const Text('No carpoolers found.')
                                  : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                        carpoolers
                                            .map(
                                              (c) => ListTile(
                                                leading: const Icon(
                                                  Icons.person,
                                                ),
                                                title: Text(c),
                                              ),
                                            )
                                            .toList(),
                                  ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class ActivitiesList extends StatelessWidget {
  final ActivitiesViewModel viewModel;
  final Future<List<String>> Function(String id) fetchCarpoolers;

  const ActivitiesList({
    super.key,
    required this.viewModel,
    required this.fetchCarpoolers,
  });

  @override
  Widget build(BuildContext context) {
    final activities = viewModel.activities ?? [];
    if (activities.isEmpty) {
      return const Center(
        child: Text(
          'No activities found.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.orange.shade200,
              child: const Icon(Icons.event, color: Colors.white),
            ),
            title: Text(
              activity.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              '${activity.location.name} - ${activity.time.format(context)}',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
            onTap: () async {
              final carpoolers = await fetchCarpoolers(activity.id.toString());
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text('Nearby Carpoolers for "${activity.name}"'),
                      content:
                          carpoolers.isEmpty
                              ? const Text('No carpoolers found.')
                              : Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    carpoolers
                                        .map(
                                          (c) => ListTile(
                                            leading: const Icon(Icons.person),
                                            title: Text(c),
                                          ),
                                        )
                                        .toList(),
                              ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
              );
            },
          ),
        );
      },
    );
  }
}
