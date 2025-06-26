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
  String? _editingOriginalEmail;

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
      _users.clear();
      _users.addAll(users);
    });
  }

  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _userRepositoryImpl.createUser(newUser);
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      setState(() {
        _users.clear();
      });
      await _loadUsers();
    }
  }

  Future<void> _editUser(String email, User user) async {
    final _editFormKey = GlobalKey<FormState>();
    _editingOriginalEmail = user.email;
    _usernameController.text = user.username;
    _emailController.text = user.email;
    _passwordController.text = user.password;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar Usuario'),
          content: Form(
            key: _editFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _emailController.clear();
                _passwordController.clear();
                _usernameController.clear();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_editFormKey.currentState!.validate()) {
                  print("Email anterior, \\$_editingOriginalEmail");
                  final newUpdateUser = User(
                    username: _usernameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  await _userRepositoryImpl.updateUser(
                      _editingOriginalEmail!, newUpdateUser);
                  _usernameController.clear();
                  _emailController.clear();
                  _passwordController.clear();
                  Navigator.of(dialogContext).pop();
                  await _loadUsers();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String email) async {
    await _userRepositoryImpl.deleteUser(email);
    await _loadUsers();
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
              child: _users.isEmpty
                  ? const Center(child: Text('No hay usuarios para mostrar'))
                  : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return ListTile(
                          title: Text(user.username),
                          subtitle: Text(user.email),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                onPressed: () => _editUser(user.email, user),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteUser(user.email),
                              ),
                            ],
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
