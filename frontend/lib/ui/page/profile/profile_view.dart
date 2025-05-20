import 'package:flutter/material.dart';
import 'package:frontend/ui/page/profile/profile_viewmodel.dart';
import 'package:frontend/ui/page/profile/points_widget.dart';
import 'package:frontend/ui/page/profile/pick_profile_picture.dart';
import 'package:frontend/ui/page/profile/profile_tab.dart';
import 'package:frontend/ui/page/profile/history_tab.dart';
import 'package:frontend/ui/page/profile/rating_tab.dart';
import 'package:frontend/ui/shared/nav/app_navigation_bar.dart';
import 'package:frontend/ui/page/rating/rating_viewmodel.dart';

class ProfileView extends StatefulWidget {
  final ProfileViewModel viewModel;
  final RatingViewModel ratingViewModel;

  const ProfileView({
    Key? key,
    required this.viewModel,
    required this.ratingViewModel,
  }) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await widget.viewModel.loadUser(1); // Replace `1` with the actual user ID
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Account')),
      body: AnimatedOpacity(
        opacity: _isLoaded ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200), // Faster fade-in
        curve: Curves.easeInOut,
        child:
            _isLoaded
                ? AnimatedBuilder(
                  animation: widget.viewModel,
                  builder:
                      (ctx, _) => DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            ProfilePicturePicker(vm: widget.viewModel),
                            const SizedBox(height: 8),
                            Text(
                              '#ABCD-0000',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            PointsWidget(
                              viewModel: widget.viewModel,
                            ), // Use ProfileViewModel
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
                                  ProfileTab(vm: widget.viewModel),
                                  const HistoryTab(),
                                  RatingTab(viewModel: widget.ratingViewModel),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                )
                : const Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: AppNavigationBar(routeName: "/profile"),
    );
  }
}
