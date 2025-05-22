import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final bool isEditing;
  final bool showPassword;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onToggleEditing;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSaveChanges;

  const ProfileTab({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.isEditing,
    required this.showPassword,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onToggleEditing,
    required this.onTogglePasswordVisibility,
    required this.onSaveChanges,
  }) : super(key: key);

  Widget _buildField({
    required String label,
    required String value,
    required bool isEditing,
    required ValueChanged<String> onChanged,
    bool obscure = false,
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child:
            isEditing
                ? TextFormField(
                  initialValue: value,
                  decoration: InputDecoration(labelText: label),
                  obscureText: obscure,
                  onChanged: onChanged,
                )
                : ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    value,
                    style: TextStyle(
                      letterSpacing:
                          label == 'Password' && !showPassword ? 2.0 : 0,
                    ),
                  ),
                  trailing: trailing,
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Tab-local edit toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: Icon(isEditing ? Icons.check : Icons.edit),
                  onPressed: onToggleEditing,
                ),
              ],
            ),
          ),

          _buildField(
            label: 'First Name',
            value: firstName,
            isEditing: isEditing,
            onChanged: onFirstNameChanged,
          ),

          _buildField(
            label: 'Last Name',
            value: lastName,
            isEditing: isEditing,
            onChanged: onLastNameChanged,
          ),

          _buildField(
            label: 'Email',
            value: email,
            isEditing: isEditing,
            onChanged: onEmailChanged,
          ),

          _buildField(
            label: 'Password',
            value:
                isEditing || showPassword
                    ? password
                    : List.filled(password.length, '*').join(),
            isEditing: isEditing,
            obscure: isEditing,
            onChanged: onPasswordChanged,
            trailing:
                !isEditing
                    ? IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: onTogglePasswordVisibility,
                    )
                    : null,
          ),

          if (isEditing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSaveChanges,
                  child: const Text('Save Changes'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
