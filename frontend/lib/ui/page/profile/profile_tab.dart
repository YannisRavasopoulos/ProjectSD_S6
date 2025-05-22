import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/form/email_field.dart';
import 'package:frontend/ui/shared/form/name_field.dart';
import 'package:frontend/ui/shared/form/password_field.dart';

class ProfileTab extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSavePressed;

  const ProfileTab({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSavePressed,
  });

  @override
  State<StatefulWidget> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool isEditing = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    emailController.text = widget.email;
    passwordController.text = widget.password;

    firstNameController.addListener(() {
      widget.onFirstNameChanged(firstNameController.text);
    });
    lastNameController.addListener(() {
      widget.onLastNameChanged(lastNameController.text);
    });
    emailController.addListener(() {
      widget.onEmailChanged(emailController.text);
    });
    passwordController.addListener(() {
      widget.onPasswordChanged(passwordController.text);
    });
  }

  void _onSaveChangesPressed() {
    widget.onSavePressed();

    setState(() {
      isEditing = false;
    });
  }

  void _onToggleEditingPressed() {
    if (isEditing) {
      widget.onSavePressed();
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(isEditing ? Icons.check : Icons.edit),
                onPressed: _onToggleEditingPressed,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: NameField(
                  readOnly: !isEditing,
                  labelText: 'First Name',
                  controller: firstNameController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: NameField(
                  readOnly: !isEditing,
                  labelText: 'Last Name',
                  controller: lastNameController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          EmailField(readOnly: !isEditing, controller: emailController),
          const SizedBox(height: 16),
          PasswordField(readOnly: !isEditing, controller: passwordController),
          if (isEditing)
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: _onSaveChangesPressed,
                child: const Text('Save Changes'),
              ),
            ),
        ],
      ),
    );
  }
}
