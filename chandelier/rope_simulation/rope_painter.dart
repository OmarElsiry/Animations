
// rope_simulation/rope_painter.dart
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:ui' as ui;
import 'rope.dart';
import 'mouse.dart';

class RopePainter extends CustomPainter {
  final List<Rope> ropes;
  final vector.Vector2 mousePosition;
  final ui.Image? lightImage;

  RopePainter({required this.ropes, required this.mousePosition, this.lightImage});

  @override
  void paint(Canvas canvas, Size size) {
    final mouse = Mouse(mousePosition);
    for (var rope in ropes) {
      rope.update(mouse);
      rope.draw(canvas, lightImage);
    }
  }

  @override
  bool shouldRepaint(covariant RopePainter oldDelegate) => true;
}
