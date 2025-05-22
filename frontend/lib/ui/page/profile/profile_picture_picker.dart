// lib/ui/profile/pick_profile_picture.dart
import 'package:flutter/material.dart';

class ProfilePicturePicker extends StatelessWidget {
  const ProfilePicturePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Smooth transition
        curve: Curves.easeInOut,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.deepPurple.shade100,
          // TODO
          backgroundImage: null,
          // vm.profileImage != null ? FileImage(vm.profileImage!) : null,
          child: const Icon(Icons.person, size: 50, color: Colors.deepPurple),
        ),
      ),
    );
  }
}
