// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fullStatusBarGraphModel.dart';

// **************************************************************************
// AutoDataGenerator
// **************************************************************************

@immutable
class FullStatusDataModel {
  final int x;
  final double y;
  final Color color;

  const FullStatusDataModel({
    @required this.x,
    @required this.y,
    @required this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FullStatusDataModel &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          color == other.color;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ color.hashCode;

  @override
  String toString() {
    return 'FullStatusDataModel{x: ' +
        x.toString() +
        ', y: ' +
        y.toString() +
        ', color: ' +
        color.toString() +
        '}';
  }

  FullStatusDataModel copyWith({
    int x,
    double y,
    Color color,
  }) {
    return FullStatusDataModel(
      x: x ?? this.x,
      y: y ?? this.y,
      color: color ?? this.color,
    );
  }

  FullStatusDataModel.fromMap(Map<String, dynamic> m)
      : x = m['x'],
        y = m['y'],
        color = m['color'];

  Map<String, dynamic> toMap() => {'x': x, 'y': y, 'color': color};

  factory FullStatusDataModel.fromJson(String json) =>
      FullStatusDataModel.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());
}
