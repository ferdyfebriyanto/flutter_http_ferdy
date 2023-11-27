import 'package:flutter/material.dart';

class EditUserDialog extends StatefulWidget {
  final String userId;
  final String currentFirstName;
  final String currentLastName;
  final String currentEmail;

  EditUserDialog({
    required this.userId,
    required this.currentFirstName,
    required this.currentLastName,
    required this.currentEmail,
  });

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.currentFirstName);
    lastNameController = TextEditingController(text: widget.currentLastName);
    emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit User'),
      content: Column(
        children: [
          TextField(
            controller: firstNameController,
            decoration: InputDecoration(labelText: 'First Name'),
          ),
          TextField(
            controller: lastNameController,
            decoration: InputDecoration(labelText: 'Last Name'),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Tambahkan logika untuk menyimpan perubahan
            final newFirstName = firstNameController.text;
            final newLastName = lastNameController.text;
            final newEmail = emailController.text;

            // Kita dapat menggunakan fungsi Navigator untuk memberikan hasil
            Navigator.of(context).pop({
              'firstName': newFirstName,
              'lastName': newLastName,
              'email': newEmail,
            });
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
