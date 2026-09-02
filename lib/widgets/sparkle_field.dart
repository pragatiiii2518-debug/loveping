import 'dart:math';
import 'package:flutter/material.dart';

class SparkleField extends StatefulWidget {
  final bool visible;

  const SparkleField({
    super.key,
    required this.visible,
  });

  @override
  State<SparkleField> createState() =>
      _SparkleFieldState();
}

class _SparkleFieldState extends State<SparkleField>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  final Random random = Random();

  final List<_Sparkle> sparkles = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..addListener(updateSparkles);

    createSparkles();

    if (widget.visible) {
      controller.repeat();
    }
  }

  @override
  void didUpdateWidget(
      covariant SparkleField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.visible &&
        !controller.isAnimating) {
      controller.repeat();
    }

    if (!widget.visible &&
        controller.isAnimating) {
      controller.stop();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //---------------------------------------------------------
  // CREATE SPARKLES
  //---------------------------------------------------------

  void createSparkles() {
    sparkles.clear();

    for (int i = 0; i < 130; i++) {
      sparkles.add(
        _Sparkle(
          x: random.nextDouble(),
          y: random.nextDouble(),

          size: 3 + random.nextDouble() * 8,

          speed: .2 + random.nextDouble(),

          opacity: .4 + random.nextDouble() * .6,
        ),
      );
    }
  }

  //---------------------------------------------------------
  // UPDATE
  //---------------------------------------------------------

  void updateSparkles() {
    for (final s in sparkles) {
      s.y -= .00045 * s.speed;

      if (s.y < -.05) {
        s.y = 1.05;
        s.x = random.nextDouble();
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  //---------------------------------------------------------
  // BUILD
  //---------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    if (!widget.visible) {
      return const SizedBox.shrink();
    }

    final screen = MediaQuery.of(context).size;

    return IgnorePointer(

      child: Stack(

        children: [

          for (final s in sparkles)

            Positioned(

              left: s.x * screen.width,

              top: s.y * screen.height,

              child: Opacity(

                opacity: s.opacity,

                child: Container(

                  width: s.size,

                  height: s.size,

                  decoration: const BoxDecoration(

                    color: Color(0xFFFFF7D6),

                    shape: BoxShape.circle,

                  ),

                ),

              ),

            ),

        ],

      ),

    );
  }
}

//---------------------------------------------------------
// MODEL
//---------------------------------------------------------

class _Sparkle {

  double x;

  double y;

  double size;

  double speed;

  double opacity;

  _Sparkle({

    required this.x,

    required this.y,

    required this.size,

    required this.speed,

    required this.opacity,

  });

}