import 'package:flutter/material.dart';
import 'package:flutter_http_ferdy/screens/user_add.dart';
import 'package:flutter_http_ferdy/screens/user_detail.dart';
import 'package:flutter_http_ferdy/screens/user_edit.dart';
import 'package:flutter_http_ferdy/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users'));

    if (response.statusCode == 200) {
      // Jika request berhasil, kita parse data JSON
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        users = data['data'];
      });
    } else {
      // Jika request gagal, tampilkan pesan error
      print('Failed to load users');
    }
  }

  Future<void> editUser(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditUserDialog(
        userId: users[index]['id'].toString(),
        currentFirstName: users[index]['first_name'],
        currentLastName: users[index]['last_name'],
        currentEmail: users[index]['email'],
      ),
    );

    if (result != null) {
      // Jika pengeditan berhasil, perbarui daftar pengguna
      final newFirstName = result['firstName'];
      final newLastName = result['lastName'];

      setState(() {
        users[index]['first_name'] = newFirstName;
        users[index]['last_name'] = newLastName;
      });

      // Selanjutnya, kirim permintaan HTTP untuk menyimpan perubahan ke server
      // Implementasikan logika HTTP PUT atau PATCH di sini
    }
  }

  Future<void> deleteUser(int index) async {
    final userId = users[index]['id'];

    final response =
        await http.delete(Uri.parse('https://reqres.in/api/users/$userId'));

    if (response.statusCode == 204) {
      // Jika penghapusan berhasil, perbarui daftar pengguna
      setState(() {
        users.removeAt(index);
      });
    } else {
      // Jika penghapusan gagal, tampilkan pesan error
      print('Failed to delete user: $userId');
    }
  }

  Future<void> addUser() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddUserDialog(),
    );

    if (result != null) {
      final firstName = result['firstName'];
      final lastName = result['lastName'];
      final email = result['email'];
      final avatar = result['avatar'];

      final response = await http.post(
        Uri.parse('https://reqres.in/api/users'),
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'avatar': avatar,
        },
      );

      if (response.statusCode == 201) {
        // Jika penambahan pengguna berhasil, perbarui daftar pengguna
        final newUser = json.decode(response.body);
        setState(() {
          users.add(newUser);
        });
      } else {
        // Jika penambahan pengguna gagal, tampilkan pesan error
        print('Failed to add user');
      }
    }
  }

  void showUserInfo(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoPage(
          userId: users[index]['id'].toString(),
          avatar: users[index]['avatar'].toString(),
          firstName: users[index]['first_name'],
          lastName: users[index]['last_name'],
          email: users[index]['email'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter HTTP Request'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(users[index]['avatar']),
            ),
            title: Text(
                users[index]['first_name'] + ' ' + users[index]['last_name']),
            subtitle: Text(users[index]['email']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => editUser(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteUser(index),
                ),
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () => showUserInfo(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        tooltip: 'Tambah Pengguna',
        child: Icon(Icons.add),
      ),
    );
  }
}
