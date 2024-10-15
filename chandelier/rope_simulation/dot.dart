
// rope_simulation/dot.dart
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'mouse.dart';

class Dot {
  vector.Vector2 pos;
  vector.Vector2 oldPos;
  double friction;
  vector.Vector2 gravity;
  double mass;
  bool pinned;

  Dot(double x, double y)
      : pos = vector.Vector2(x, y),
        oldPos = vector.Vector2(x, y),
        friction = 0.97,
        gravity = vector.Vector2(0, 0.6),
        mass = 1,
        pinned = false;

  void update(Mouse mouse) {
    if (pinned) return;
    final vel = pos - oldPos;
    oldPos.setFrom(pos);
    vel.scale(friction);
    vel.add(gravity);
    final diff = mouse.pos - pos;
    final dist = diff.length;
    final force = (mouse.radius - dist) / mouse.radius;
    if (force > 0.6) {
      pos.setFrom(mouse.pos);
    } else {
      pos.add(vel);
      pos.add(diff.normalized().scaled(force));
    }
  }

  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(pos.x, pos.y), mass, paint);
  }
}
