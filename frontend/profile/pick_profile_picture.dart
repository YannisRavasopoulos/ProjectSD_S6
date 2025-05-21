// lib/ui/profile/pick_profile_picture.dart
import 'package:flutter/material.dart';
import 'profile_viewmodel.dart';

class ProfilePicturePicker extends StatelessWidget {
  final ProfileViewModel vm;

  const ProfilePicturePicker({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Smooth transition
        curve: Curves.easeInOut,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.deepPurple.shade100,
          backgroundImage:
              vm.profileImage != null ? FileImage(vm.profileImage!) : null,
          child: vm.profileImage == null
              ? const Icon(Icons.person, size: 50, color: Colors.deepPurple)
              : null,
        ),
      ),
    );
  }
}
