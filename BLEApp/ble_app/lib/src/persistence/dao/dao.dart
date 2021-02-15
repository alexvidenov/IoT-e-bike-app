import 'package:ble_app/src/persistence/entities/model.dart';
import 'package:floor/floor.dart';

@dao
abstract class Dao<T extends Model> {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertEntity(T entity);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertList(List<T> entities);

  @delete
  Future<void> deleteEntity(T entity);

  @update
  Future<void> updateEntity(T entity);
}
