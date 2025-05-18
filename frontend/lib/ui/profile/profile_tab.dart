// lib/ui/profile/profile_tab.dart
import 'package:flutter/material.dart';
import 'profile_viewmodel.dart';

class ProfileTab extends StatelessWidget {
  final ProfileViewModel vm;
  const ProfileTab({Key? key, required this.vm}) : super(key: key);

  Widget _buildField({
    required String label,
    required String value,
    required bool isEditing,
    required ValueChanged<String> onChanged,
    bool obscure = false,
    Widget? trailing, // for show/hide eye
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: isEditing
            // Editable TextFormField
            ? TextFormField(
                initialValue: value,
                decoration: InputDecoration(labelText: label),
                obscureText: obscure,
                onChanged: onChanged,
              )
            // Read-only ListTile
            : ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  value,
                  style: TextStyle(
                      letterSpacing: label == 'Password' && !vm.showPassword
                          ? 2.0
                          : 0),
                ),
                trailing: trailing,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (vm.user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Tab-local edit toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Profile Details',
                    style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: Icon(vm.isEditing ? Icons.check : Icons.edit),
                  onPressed: vm.toggleEditing,
                ),
              ],
            ),
          ),

          _buildField(
            label: 'First Name',
            value: vm.user!.firstName,
            isEditing: vm.isEditing,
            onChanged: vm.updateFirstName,
          ),

          _buildField(
            label: 'Last Name',
            value: vm.user!.lastName,
            isEditing: vm.isEditing,
            onChanged: vm.updateLastName,
          ),

          _buildField(
            label: 'Email',
            value: vm.user!.email,
            isEditing: vm.isEditing,
            onChanged: vm.updateEmail,
          ),

          _buildField(
            label: 'Password',
            value: vm.showPassword || vm.isEditing
                ? vm.user!.password
                : List.filled(vm.user!.password.length, '*').join(),
            isEditing: vm.isEditing,
            obscure: vm.isEditing,
            onChanged: vm.updatePassword,
            trailing: !vm.isEditing
                ? IconButton(
                    icon: Icon(vm.showPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: vm.togglePasswordVisibility,
                  )
                : null,
          ),

          // Save Changes button
          if (vm.isEditing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.saveChanges,
                  child: const Text('Save Changes'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
