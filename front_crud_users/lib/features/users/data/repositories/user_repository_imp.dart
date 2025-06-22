import 'package:front_crud_users/features/users/data/datasources/user_remote_datasource.dart';
import 'package:front_crud_users/features/users/data/models/user_model.dart';
import 'package:front_crud_users/features/users/domain/dtos/update_user_dto.dart';
import 'package:front_crud_users/features/users/domain/entities/user.dart';
import 'package:front_crud_users/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> createUser(User user) async {
    final newUserModel = UserModel(
      username: user.username,
      email: user.email,
      password: user.password,
    );
    await remoteDatasource.createUser(newUserModel);
  }

  @override
  Future<List<User>> getUsers() async {
    final models = await remoteDatasource.fetchUsers();
    return models;
  }

  final List<UserModel> _users = [];

  @override
  Future<void> updateUser(String email, User user) async {
    //final index = _users.indexWhere((u) => u.email == user.email);
    /*if (index != -1) {
      
      /*_users[index] = UserModel(
          username: user.username,
          email: user.email,
          password: user.password,
          newEmail: user.newEmail);*/
    }*/

    final newUserModel = UpdateUserDto(
      username: user.username,
      newEmail: user.email,
      password: user.password,
    );

    await remoteDatasource.updateUser(email, newUserModel);
  }

  @override
  Future<void> deleteUser(String email) async {
    _users.removeWhere((u) => u.email == email);
    await remoteDatasource.deleteUser(email);
  }
}
