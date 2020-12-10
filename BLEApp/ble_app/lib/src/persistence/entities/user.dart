import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User {
  @PrimaryKey()
  final String id;

  final String email;
  final String password; // TODO: needs to be hashed

  const User(this.id, this.email, this.password);
}
