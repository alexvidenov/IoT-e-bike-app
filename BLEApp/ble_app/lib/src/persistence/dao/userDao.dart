import 'package:ble_app/src/persistence/dao/dao.dart';
import 'package:ble_app/src/persistence/entities/user.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao extends Dao<User> {
  @Query('SELECT * FROM users')
  Future<List<User>> fetchUsers();

  @Query('SELECT * FROM users WHERE email = :email')
  Future<User> fetchUser(String email);

  @Query('SELECT * FROM users WHERE email = :email')
  Future<User> isUserSignedInAnonymously(String email);
}
