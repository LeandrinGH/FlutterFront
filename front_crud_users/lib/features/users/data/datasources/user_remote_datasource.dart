import 'package:front_crud_users/features/users/domain/dtos/update_user_dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_crud_users/features/users/data/models/user_model.dart';

abstract class UserRemoteDatasource {
  Future<List<UserModel>> fetchUsers();
  Future<void> createUser(UserModel user);
  Future<void> deleteUser(String email);
  Future<void> updateUser(String email, UpdateUserDto user);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final http.Client client;

  UserRemoteDatasourceImpl(this.client);

  @override
  Future<List<UserModel>> fetchUsers() async {
    final response = await client.get(Uri.parse('http://localhost:3001/user'));
    final List data = jsonDecode(response.body);
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  @override
  Future<void> createUser(UserModel user) async {
    await client.post(
      Uri.parse('http://localhost:3001/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
  }

  @override
  Future<void> deleteUser(String email) async {
    await client.delete(
      Uri.parse('http://localhost:3001/user/$email'),
    );
  }

  @override
  Future<void> updateUser(String email, UpdateUserDto user) async {
    print("$email and ${user.newEmail}, ${user.username}, ${user.password}");

    await client.put(
      Uri.parse('http://localhost:3001/user/$email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
  }
}
