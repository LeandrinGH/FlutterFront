import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_crud_users/features/users/data/models/user_model.dart';

abstract class UserRemoteDatasource {
  Future<List<UserModel>> fetchUsers();
  Future<void> createUser(UserModel user);
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
}
