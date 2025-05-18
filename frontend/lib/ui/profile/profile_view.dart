// lib/ui/profile/profile_view.dart
import 'package:flutter/material.dart';
import 'profile_viewmodel.dart';
import 'points_widget.dart';
import 'pick_profile_picture.dart';
import 'profile_tab.dart';
import 'history_tab.dart';
import 'rating_tab.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);
  final vm = ProfileViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Account')),
      body: AnimatedBuilder(
        animation: vm,
        builder: (ctx, _) => DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const SizedBox(height: 24),
              ProfilePicturePicker(vm: vm),
              const SizedBox(height: 8),
              Text('#ABCD-0000',
                  style: Theme.of(context).textTheme.bodyMedium),
              PointsWidget(points: 1280),

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
                    ProfileTab(vm: vm),
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
  }
}
