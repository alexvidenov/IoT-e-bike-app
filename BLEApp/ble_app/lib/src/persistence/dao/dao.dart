import 'package:floor/floor.dart';

@dao
abstract class Dao<T> {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertEntity(T entity);
}