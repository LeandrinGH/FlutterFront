import 'package:front_crud_users/features/users/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> createUser(User user);
  Future<List<User>> getUsers();
  Future<void> updateUser(User user);
  Future<void> deleteUser(String email);
}
