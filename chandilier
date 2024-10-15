import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class RopeSimulationPage extends StatefulWidget {
  const RopeSimulationPage({super.key});

  @override
  RopeSimulationPageState createState() => RopeSimulationPageState();
}

class RopeSimulationPageState extends State<RopeSimulationPage>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late List<Rope> ropes;
  vector.Vector2 mousePosition = vector.Vector2(-1000, -1000);
  ui.Image? lightImage;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
    ropes = [];
    _loadLightImage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createRopes();
    });
  }

  void _loadLightImage() async {
    final ByteData data =
        await DefaultAssetBundle.of(context).load('assets/light.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frameInfo = await codec.getNextFrame();
    setState(() {
      lightImage = frameInfo.image;
    });
  }

  void createRopes() {
    final size = MediaQuery.of(context).size;
    final total = (size.width * 0.04).floor();

    for (int i = 0; i < total + 1; i++) {
      final x = randomBetween(size.width * 0.3, size.width * 0.7);
      const y = 0.0;
      final gap = randomBetween(size.height * 0.05, size.height * 0.08);
      const segments = 8;
      final rope = Rope(x: x, y: y, gap: gap, segments: segments);
      rope.pin(0);
      ropes.add(rope);
    }
  }

  void _tick(Duration elapsed) {
    setState(() {
      // Update simulation here
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: GestureDetector(
        onPanUpdate: (details) {
          mousePosition.setValues(
              details.localPosition.dx, details.localPosition.dy);
        },
        child: CustomPaint(
          painter: RopePainter(
              ropes: ropes,
              mousePosition: mousePosition,
              lightImage: lightImage),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class RopePainter extends CustomPainter {
  final List<Rope> ropes;
  final vector.Vector2 mousePosition;
  final ui.Image? lightImage;

  RopePainter(
      {required this.ropes, required this.mousePosition, this.lightImage});

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

class Mouse {
  vector.Vector2 pos;
  double radius;

  Mouse(this.pos) : radius = 40;
}

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

    final force = max((mouse.radius - dist) / mouse.radius, 0).toDouble();

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
    canvas.drawLine(Offset(startPoint.pos.x, startPoint.pos.y),
        Offset(endPoint.pos.x, endPoint.pos.y), paint);
  }
}

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

    // Draw light at the end of the rope
    if (lightImage != null) {
      const lightSize = 30.0;
      final srcRect = Rect.fromLTWH(
          0, 0, lightImage.width.toDouble(), lightImage.height.toDouble());
      final dstRect = Rect.fromCenter(
        center: Offset(dots.last.pos.x, dots.last.pos.y),
        width: lightSize,
        height: lightSize,
      );
      canvas.drawImageRect(lightImage, srcRect, dstRect, Paint());
    }
  }
}

double randomBetween(double min, double max) {
  return min + Random().nextDouble() * (max - min);
}
