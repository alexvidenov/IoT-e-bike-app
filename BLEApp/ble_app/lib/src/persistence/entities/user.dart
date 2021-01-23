import 'package:ble_app/src/persistence/entities/model.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User extends Model {
  final String email;
  final String password; // TODO: needs to be hashed

  const User(String id, this.email, this.password) : super(id: id);
}
