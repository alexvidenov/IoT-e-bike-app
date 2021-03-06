import 'package:ble_app/src/persistence/entities/model.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User extends Model {
  final String username;
  final String password; // TODO: needs to be hashed
  const User(String id, this.username, this.password) : super(id: id);
}
