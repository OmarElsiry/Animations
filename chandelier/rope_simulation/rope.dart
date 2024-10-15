
// rope_simulation/rope.dart
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dot.dart';
import 'stick.dart';
import 'mouse.dart';

class Rope {
  double x;
  double y;
  int segments;
  double gap;
  List<Dot> dots;
  List<Stick> sticks;
  int iterations;

  Rope({required this.x, required this.y, this.segments = 8, required this.gap})
      : dots = [],
        sticks = [],
        iterations = 5 {
    create();
  }

  void pin(int index) {
    dots[index].pinned = true;
  }

  void create() {
    for (int i = 0; i < segments; i++) {
      dots.add(Dot(x, y + i * gap));
    }
    for (int i = 0; i < segments - 1; i++) {
      sticks.add(Stick(dots[i], dots[i + 1]));
    }
  }

  void update(Mouse mouse) {
    for (var dot in dots) {
      dot.update(mouse);
    }
    for (int i = 0; i < iterations; i++) {
      for (var stick in sticks) {
        stick.update();
      }
    }
  }

  void draw(Canvas canvas, ui.Image? lightImage) {
    for (var stick in sticks) {
      stick.draw(canvas);
    }
    for (var dot in dots) {
      dot.draw(canvas);
    }
    if (lightImage != null) {
      const lightSize = 30.0;
      final srcRect = Rect.fromLTWH(
        0,
        0,
        lightImage.width.toDouble(),
        lightImage.height.toDouble(),
      );
      final dstRect = Rect.fromCenter(
        center: Offset(dots.last.pos.x, dots.last.pos.y),
        width: lightSize,
        height: lightSize,
      );
      canvas.drawImageRect(lightImage, srcRect, dstRect, Paint());
    }
  }
}
