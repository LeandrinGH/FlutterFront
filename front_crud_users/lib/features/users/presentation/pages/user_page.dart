import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front_crud_users/features/users/data/datasources/user_remote_datasource.dart';
import 'package:front_crud_users/features/users/data/repositories/user_repository_imp.dart';
import 'package:front_crud_users/features/users/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  final List<User> _users = [];
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final UserRepositoryImpl _userRepositoryImpl;

  @override
  void initState() {
    super.initState();
    _userRepositoryImpl =
        UserRepositoryImpl(UserRemoteDatasourceImpl(http.Client()));
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _userRepositoryImpl.getUsers();
    setState(() {
      _users.addAll(users);
    });
  }

  void _addUser() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _userRepositoryImpl.createUser(User(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ));
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _users.clear();
        sleep(0.5 as Duration);
        _loadUsers();
      });
    }
  }

  void _deleteUser(String email) {
    setState(() {
      _users.removeWhere((user) => user.email == email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Usuarios')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration:
                        const InputDecoration(labelText: 'Nombre de usuario'),
                    validator: (value) =>
                        value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                    validator: (value) =>
                        value!.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addUser,
                    child: const Text('Agregar Usuario'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    title: Text(user.username),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteUser(user.email),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
