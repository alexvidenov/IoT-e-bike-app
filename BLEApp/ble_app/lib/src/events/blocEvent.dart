import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocEvent.freezed.dart';

@freezed
abstract class BlocEvent with _$BlocEvent {
  const factory BlocEvent.created() = Create;

  const factory BlocEvent.pause() = Pause;

  const factory BlocEvent.resume() = Resume;

  const factory BlocEvent.dispose() = Dispose;
}
