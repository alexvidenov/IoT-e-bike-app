import 'dart:math';

import 'package:flutter/material.dart';

class Speedometer extends StatelessWidget {
  Speedometer({
    @required this.speed,
    @required this.speedRecord,
    this.size = 300
  });

  final double speed;
  final double speedRecord;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: SpeedometerPainter(
            speed: speed,
            speedRecord: speedRecord
        ),
        size: Size(size, size)
    );
  }
}

class SpeedometerPainter extends CustomPainter {
  SpeedometerPainter({
    this.speed,
    this.speedRecord
  });

  final double speed;
  final double speedRecord;

  Size size;
  Canvas canvas;
  Offset center;
  Paint paintObject;

  @override
  void paint(Canvas canvas, Size size) {
    _init(canvas, size);

    _drawOuterCircle();
    _drawInnerCircle();
    _drawMarkers();
    _drawSpeedIndicators(size);
  }

  void _drawSpeedIndicators(Size size) {
    for (double percentage = 0.15; percentage <= 0.85; percentage += 4 / (size.width)) {
      _drawSpeedIndicator(percentage);
    }

    for (double percentage = 0.15; percentage < 0.15 + (speed / 100); percentage += 4 / (size.width)) {
      _drawSpeedIndicator(percentage, true);
    }
  }

  void _drawMarkers() {
    paintObject.style = PaintingStyle.fill;

    for (double relativeRotation = 0.15; relativeRotation <= 0.851; relativeRotation += 0.01) {
      double normalizedDouble = double.parse((relativeRotation - 0.15).toStringAsFixed(2));
      int normalizedPercentage = (normalizedDouble * 100).toInt();
      bool isBigMarker = normalizedPercentage % 10 == 0;

      _drawRotated(
          relativeRotation,
              () => _drawMarker(isBigMarker)
      );

      if (isBigMarker)
        _drawRotated(
            relativeRotation,
                () => _drawSpeedScaleText(relativeRotation, normalizedPercentage.toString())
        );
    }
  }

  void _drawSpeedIndicator(double relativeRotation, [bool highlight = false]) {
    paintObject.shader = null;
    paintObject.strokeWidth = 1;
    paintObject.style = PaintingStyle.stroke;
    paintObject.color = Colors.white54;

    if (highlight) {
      paintObject.color = Color.lerp(
          Colors.yellow, Colors.red, (relativeRotation - 0.15) / 0.7
      );
      paintObject.style = PaintingStyle.fill;
    }

    Path markerPath = Path()
      ..addRect(
          Rect.fromLTRB(
              center.dx - size.width / 40,
              size.width - (size.width / 30),
              center.dx,
              size.width - (size.width / 100)
          )
      );

    _drawRotated(relativeRotation, () {
      canvas.drawPath(markerPath, paintObject);
    });
  }

  void _init(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.size = size;
    center = size.center(Offset.zero);
    paintObject = Paint();
  }

  void _drawRotated(double angle, Function drawFunction) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle * pi * 2);
    canvas.translate(-center.dx, -center.dy);
    drawFunction();
    canvas.restore();
  }

  void _drawMarker(bool isBigMarker) {
    paintObject
      ..color = Colors.red
      ..shader = null;

    Path markerPath = Path()
      ..addRect(
          Rect.fromLTRB(
            center.dx - size.width / (isBigMarker ? 200 : 300),
            center.dy + (size.width / 2.2),
            center.dx + size.width / (isBigMarker ? 200 : 300),
            center.dy + (size.width / (isBigMarker ? 2.5 : 2.35)),
          )
      );

    canvas.drawPath(markerPath, paintObject);
  }

  void _drawSpeedScaleText(double rotation, String text) {
    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: size.width / 20
        ),
        text: text
    );
    TextPainter textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center
    );

    textPainter.layout();

    final textCenter = Offset(
        center.dx,
        size.width - (size.width / 5.5) + (textPainter.width / 2)
    );

    final textTopLeft = Offset(
        textCenter.dx - (textPainter.width / 2),
        textCenter.dy - (textPainter.height / 2)
    );

    canvas.save();

    // Rotate the canvas around the position of the text so that the text is oriented properly

    canvas.translate(
        textCenter.dx,
        textCenter.dy
    );
    canvas.rotate(-rotation * pi * 2);
    canvas.translate(
        -textCenter.dx,
        -textCenter.dy
    );

    textPainter.paint(canvas, textTopLeft);

    canvas.restore();
  }

  void _drawInnerCircle() {
    paintObject
      ..color = Colors.red.withOpacity(0.4)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
        size.center(Offset.zero),
        size.width / 4,
        paintObject
    );
  }

  void _drawOuterCircle() {
    paintObject
      ..color = Colors.red
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
        size.center(Offset.zero),
        size.width / 2.2,
        paintObject
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}