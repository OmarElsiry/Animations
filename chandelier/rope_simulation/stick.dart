
// rope_simulation/stick.dart
import 'package:flutter/material.dart';
import 'dot.dart';

class Stick {
  Dot startPoint;
  Dot endPoint;
  double length;
  double tension;

  Stick(this.startPoint, this.endPoint)
      : length = (startPoint.pos - endPoint.pos).length,
        tension = 0.3;

  void update() {
    final diff = endPoint.pos - startPoint.pos;
    final dist = diff.length;
    final difference = (dist - length) / dist;
    final offset = diff.scaled(difference * tension);
    final m = startPoint.mass + endPoint.mass;
    final m1 = endPoint.mass / m;
    final m2 = startPoint.mass / m;
    if (!startPoint.pinned) {
      startPoint.pos.add(offset.scaled(m1));
    }
    if (!endPoint.pinned) {
      endPoint.pos.sub(offset.scaled(m2));
    }
  }

  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(startPoint.pos.x, startPoint.pos.y),
      Offset(endPoint.pos.x, endPoint.pos.y),
      paint,
    );
  }
}
