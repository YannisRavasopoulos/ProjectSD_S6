import 'package:flutter/material.dart';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/ui/page/profile/history_tab.dart';
import 'package:frontend/ui/page/profile/profile_picture_picker.dart';
import 'package:frontend/ui/page/profile/profile_viewmodel.dart';
import 'package:frontend/ui/page/profile/rating_tab.dart';
import 'package:frontend/ui/page/profile/profile_tab.dart';
// import 'package:frontend/ui/page/profile/points_widget.dart';
import 'package:frontend/ui/shared/nav/app_navigation_bar.dart';

class ProfileView extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : AnimatedBuilder(
                animation: viewModel,
                builder:
                    (ctx, _) => DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          ProfilePicturePicker(),
                          const SizedBox(height: 8),
                          Text(
                            '#ABCD-0000',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          // PointsWidget(viewModel: widget.viewModel),
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
                              physics:
                                  const BouncingScrollPhysics(), // Smooth scrolling
                              children: [
                                ProfileTab(
                                  email: viewModel.email,
                                  firstName: viewModel.firstName,
                                  lastName: viewModel.lastName,
                                  password: viewModel.password,
                                  onEmailChanged: viewModel.onEmailChanged,
                                  onFirstNameChanged:
                                      viewModel.onFirstNameChanged,
                                  onLastNameChanged:
                                      viewModel.onLastNameChanged,
                                  onPasswordChanged:
                                      viewModel.onPasswordChanged,
                                  onSavePressed: viewModel.saveChanges,
                                ),
                                HistoryTab(onClearHistory: () {}, rides: []),
                                RatingTab(
                                  ratings: List.generate(
                                    5,
                                    (idx) => Rating.random(),
                                  ),
                                  averageRating: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              );
        },
      ),
      bottomNavigationBar: AppNavigationBar(routeName: "/profile"),
    );
  }
}
