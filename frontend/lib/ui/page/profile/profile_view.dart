import 'package:flutter/material.dart';
import 'package:frontend/ui/page/profile/history_tab.dart';
import 'package:frontend/ui/page/profile/points_widget.dart';
import 'package:frontend/ui/page/profile/profile_picture_picker.dart';
import 'package:frontend/ui/page/profile/profile_viewmodel.dart';
import 'package:frontend/ui/page/profile/rating_tab.dart';
import 'package:frontend/ui/page/profile/profile_tab.dart';
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
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                        PointsWidget(points: viewModel.points),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: _buildContents(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AppNavigationBar(routeName: "/profile"),
    );
  }

  Widget _buildContents(BuildContext context) {
    return TabBarView(
      physics: const BouncingScrollPhysics(),
      children: [
        ProfileTab(
          email: viewModel.email,
          firstName: viewModel.firstName,
          lastName: viewModel.lastName,
          password: viewModel.password,
          onEmailChanged: viewModel.onEmailChanged,
          onFirstNameChanged: viewModel.onFirstNameChanged,
          onLastNameChanged: viewModel.onLastNameChanged,
          onPasswordChanged: viewModel.onPasswordChanged,
          onSavePressed: viewModel.saveChanges,
        ),
        HistoryTab(
          onClearHistory: viewModel.clearHistory,
          rides: viewModel.rides,
        ),
        RatingTab(
          ratings: viewModel.ratings,
          averageRating: viewModel.averageRating,
        ),
      ],
    );
  }
}
