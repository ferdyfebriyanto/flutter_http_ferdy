import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddUserDialog extends StatefulWidget {
  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  File? _image;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Pengguna'),
      content: Column(
        children: [
          _image != null
              ? Image.file(
                  _image!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
              : Placeholder(
                  fallbackHeight: 100,
                  fallbackWidth: 100,
                ),
          ElevatedButton(
            onPressed: _getImage,
            child: Text('Pilih Gambar'),
          ),
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
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            // Tambahkan logika untuk menyimpan perubahan
            final firstName = firstNameController.text;
            final lastName = lastNameController.text;
            final email = emailController.text;

            Navigator.of(context).pop({
              'firstName': firstName,
              'lastName': lastName,
              'email': email,
              'avatar': 'https://reqres.in/img/faces/1-image.jpg',
            });
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}
