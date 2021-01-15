// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'blocEvent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$BlocEventTearOff {
  const _$BlocEventTearOff();

// ignore: unused_element
  Create created() {
    return const Create();
  }

// ignore: unused_element
  Pause pause() {
    return const Pause();
  }

// ignore: unused_element
  Resume resume() {
    return const Resume();
  }

// ignore: unused_element
  Dispose dispose() {
    return const Dispose();
  }
}

/// @nodoc
// ignore: unused_element
const $BlocEvent = _$BlocEventTearOff();

/// @nodoc
mixin _$BlocEvent {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result created(),
    @required Result pause(),
    @required Result resume(),
    @required Result dispose(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result created(),
    Result pause(),
    Result resume(),
    Result dispose(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result created(Create value),
    @required Result pause(Pause value),
    @required Result resume(Resume value),
    @required Result dispose(Dispose value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result created(Create value),
    Result pause(Pause value),
    Result resume(Resume value),
    Result dispose(Dispose value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $BlocEventCopyWith<$Res> {
  factory $BlocEventCopyWith(BlocEvent value, $Res Function(BlocEvent) then) =
      _$BlocEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$BlocEventCopyWithImpl<$Res> implements $BlocEventCopyWith<$Res> {
  _$BlocEventCopyWithImpl(this._value, this._then);

  final BlocEvent _value;
  // ignore: unused_field
  final $Res Function(BlocEvent) _then;
}

/// @nodoc
abstract class $CreateCopyWith<$Res> {
  factory $CreateCopyWith(Create value, $Res Function(Create) then) =
      _$CreateCopyWithImpl<$Res>;
}

/// @nodoc
class _$CreateCopyWithImpl<$Res> extends _$BlocEventCopyWithImpl<$Res>
    implements $CreateCopyWith<$Res> {
  _$CreateCopyWithImpl(Create _value, $Res Function(Create) _then)
      : super(_value, (v) => _then(v as Create));

  @override
  Create get _value => super._value as Create;
}

/// @nodoc
class _$Create implements Create {
  const _$Create();

  @override
  String toString() {
    return 'BlocEvent.created()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Create);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result created(),
    @required Result pause(),
    @required Result resume(),
    @required Result dispose(),
  }) {
    assert(created != null);
    assert(pause != null);
    assert(resume != null);
    assert(dispose != null);
    return created();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result created(),
    Result pause(),
    Result resume(),
    Result dispose(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (created != null) {
      return created();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result created(Create value),
    @required Result pause(Pause value),
    @required Result resume(Resume value),
    @required Result dispose(Dispose value),
  }) {
    assert(created != null);
    assert(pause != null);
    assert(resume != null);
    assert(dispose != null);
    return created(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result created(Create value),
    Result pause(Pause value),
    Result resume(Resume value),
    Result dispose(Dispose value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (created != null) {
      return created(this);
    }
    return orElse();
  }
}

abstract class Create implements BlocEvent {
  const factory Create() = _$Create;
}

/// @nodoc
abstract class $PauseCopyWith<$Res> {
  factory $PauseCopyWith(Pause value, $Res Function(Pause) then) =
      _$PauseCopyWithImpl<$Res>;
}

/// @nodoc
class _$PauseCopyWithImpl<$Res> extends _$BlocEventCopyWithImpl<$Res>
    implements $PauseCopyWith<$Res> {
  _$PauseCopyWithImpl(Pause _value, $Res Function(Pause) _then)
      : super(_value, (v) => _then(v as Pause));

  @override
  Pause get _value => super._value as Pause;
}

/// @nodoc
class _$Pause implements Pause {
  const _$Pause();

  @override
  String toString() {
    return 'BlocEvent.pause()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Pause);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result created(),
    @required Result pause(),
    @required Result resume(),
    @required Result dispose(),
  }) {
    assert(created != null);
    assert(pause != null);
    assert(resume != null);
    assert(dispose != null);
    return pause();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result created(),
    Result pause(),
    Result resume(),
    Result dispose(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (pause != null) {
      return pause();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result created(Create value),
    @required Result pause(Pause value),
    @required Result resume(Resume value),
    @required Result dispose(Dispose value),
  }) {
    assert(created != null);
    assert(pause != null);
    assert(resume != null);
    assert(dispose != null);
    return pause(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result created(Create value),
    Result pause(Pause value),
    Result resume(Resume value),
    Result dispose(Dispose value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (pause != null) {
      return pause(this);
    }
    return orElse();
  }
}

abstract class Pause implements BlocEvent {
  const factory Pause() = _$Pause;
}

/// @nodoc
abstract class $ResumeCopyWith<$Res> {
  factory $ResumeCopyWith(Resume value, $Res Function(Resume) then) =
      _$ResumeCopyWithImpl<$Res>;
}

/// @nodoc
class _$ResumeCopyWithImpl<$Res> extends _$BlocEventCopyWithImpl<$Res>
    implements $ResumeCopyWith<$Res> {
  _$ResumeCopyWithImpl(Resume _value, $Res Function(Resume) _then)
      : super(_value, (v) => _then(v as Resume));

  @override
  Resume get _value => super._value as Resume;
}

/// @nodoc
class _$Resume implements Resume {
  const _$Resume();

  @override
  String toString() {
    return 'BlocEvent.resume()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Resume);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result created(),
    @required Result pause(),
    @required Result resume(),
    @required Result dispose(),
  }) {
    assert(created != null);
    assert(pause != null);
    assert(resume != null);
    assert(dispose != null);
    return resume();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result created(),
    Result pause(),
    Result resume(),
    Result dispose(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (resume != null) {
      return resume();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result created(Create value),
    @required Result pause(Pause value),
    @required Result resume(Resume value),
    @required Result dispose(Dispose value),
  }) {
    assert(created != null);
    assert(pause != null);
    assert(resume != null);
    assert(dispose != null);
    return resume(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result created(Create value),
    Result pause(Pause value),
    Result resume(Resume value),
    Result dispose(Dispose value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (resume != null) {
      return resume(this);
    }
    return orElse();
  }
}

abstract class Resume implements BlocEvent {
  const factory Resume() = _$Resume;
}

/// @nodoc
abstract class $DisposeCopyWith<$Res> {
  factory $DisposeCopyWith(Dispose value, $Res Function(Dispose) then) =
      _$DisposeCopyWithImpl<$Res>;
}

/// @nodoc
class _$DisposeCopyWithImpl<$Res> extends _$BlocEventCopyWithImpl<$Res>
    implements $DisposeCopyWith<$Res> {
  _$DisposeCopyWithImpl(Dispose _value, $Res Function(Dispose) _then)
      : super(_value, (v) => _then(v as Dispose));

  @override
  Dispose get _value => super._value as Dispose;
}

/// @nodoc
class _$Dispose implements Dispose {
  const _$Dispose();

  @override
  String toString() {
    return 'BlocEvent.dispose()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Dispose);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result created(),
    @required Result pause(),
    @required Result resume(),
    @required Result dispose(),
  }) {
    assert(created != null);
    assert(pause != null);
    assert(resume != null);
    assert(dispose != null);
    return dispose();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result created(),
    Result pause(),
    Result resume(),
    Result dispose(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (dispose != null) {
      return dispose();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result created(Create value),
    @required Result pause(Pause value),
    @required Result resume(Resume value),
    @required Result dispose(Dispose value),
  }) {
    assert(created != null);
    assert(pause != null);
    assert(resume != null);
    assert(dispose != null);
    return dispose(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result created(Create value),
    Result pause(Pause value),
    Result resume(Resume value),
    Result dispose(Dispose value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (dispose != null) {
      return dispose(this);
    }
    return orElse();
  }
}

abstract class Dispose implements BlocEvent {
  const factory Dispose() = _$Dispose;
}
