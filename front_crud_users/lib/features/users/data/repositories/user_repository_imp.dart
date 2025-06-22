import 'package:front_crud_users/features/users/data/datasources/user_remote_datasource.dart';
import 'package:front_crud_users/features/users/data/models/user_model.dart';
import 'package:front_crud_users/features/users/domain/entities/user.dart';
import 'package:front_crud_users/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> createUser(User user) async {
    final model = UserModel(
      username: user.username,
      email: user.email,
      password: user.password,
    );
    await remoteDatasource.createUser(model);
  }

  @override
  Future<List<User>> getUsers() async {
    final models = await remoteDatasource.fetchUsers();
    return models;
  }

  final List<UserModel> _users = [];

  @override
  Future<void> updateUser(User user) async {
    final index = _users.indexWhere((u) => u.email == user.email);
    if (index != -1) {
      _users[index] = UserModel(
        username: user.username,
        email: user.email,
        password: user.password,
      );
    }
  }

  @override
  Future<void> deleteUser(String email) async {
    _users.removeWhere((u) => u.email == email);
  }
}
