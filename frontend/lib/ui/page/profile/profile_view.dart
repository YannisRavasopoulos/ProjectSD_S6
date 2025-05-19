// lib/ui/profile/profile_view.dart
import 'package:flutter/material.dart';
import 'package:frontend/ui/page/profile/profile_viewmodel.dart';
import 'package:frontend/ui/shared/points.dart'; // Updated import
import 'package:frontend/ui/page/profile/pick_profile_picture.dart';
import 'package:frontend/ui/page/profile/profile_tab.dart';
import 'package:frontend/ui/page/profile/history_tab.dart';
import 'package:frontend/ui/page/profile/rating_tab.dart';

class ProfileView extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileView({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.loadUser(1), // Replace `1` with the actual user ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading profile: ${snapshot.error}'),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('My Account')),
          body: AnimatedBuilder(
            animation: viewModel,
            builder:
                (ctx, _) => DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      ProfilePicturePicker(vm: viewModel),
                      const SizedBox(height: 8),
                      Text(
                        '#ABCD-0000',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Points(points: viewModel.user?.points ?? 0),
                      const SizedBox(height: 16),
                      const TabBar(
                        indicatorColor: Colors.deepPurple,
                        labelColor: Colors.deepPurple,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: 'Profile'),
                          Tab(text: 'History'),
                          Tab(text: 'Rating'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ProfileTab(vm: viewModel),
                            const HistoryTab(),
                            const RatingTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        );
      },
    );
  }
}
