import 'package:ble_app/src/di/serviceLocator.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final $ = GetIt.instance;

@injectableInit
configureDependencies() => $initGetIt($);
