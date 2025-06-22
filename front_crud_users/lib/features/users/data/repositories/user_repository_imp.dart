import 'package:front_crud_users/features/users/data/models/user_model.dart';
import 'package:front_crud_users/features/users/domain/entities/user.dart';
import 'package:front_crud_users/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final List<UserModel> _users = [];

  @override
  Future<void> createUser(User user) async {
    _users.add(UserModel(
      username: user.username,
      email: user.email,
      password: user.password,
    ));
  }

  @override
  Future<List<User>> getUsers() async => _users;

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
