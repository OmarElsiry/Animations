

// rope_simulation/rope_simulation_page.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'rope_painter.dart';
import 'rope.dart';
import 'utils.dart';

class RopeSimulationPage extends StatefulWidget {
  const RopeSimulationPage({super.key});

  @override
  RopeSimulationPageState createState() => RopeSimulationPageState();
}

class RopeSimulationPageState extends State<RopeSimulationPage> with SingleTickerProviderStateMixin {
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
    final ByteData data = await DefaultAssetBundle.of(context).load('assets/light.png');
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
            details.localPosition.dx,
            details.localPosition.dy,
          );
        },
        child: CustomPaint(
          painter: RopePainter(
            ropes: ropes,
            mousePosition: mousePosition,
            lightImage: lightImage,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}
