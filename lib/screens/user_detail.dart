import 'package:flutter/material.dart';

class UserInfoPage extends StatelessWidget {
  final String userId;
  final String avatar;
  final String firstName;
  final String lastName;
  final String email;

  UserInfoPage({
    required this.userId,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              // Gantilah URL sesuai dengan URL avatar dari API
              backgroundImage: NetworkImage('$avatar'),
            ),
            SizedBox(height: 16),
            Text('User ID: $userId'),
            Text('Name: $firstName $lastName'),
            Text('Email: $email'),
          ],
        ),
      ),
    );
  }
}
