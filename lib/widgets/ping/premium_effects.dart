import 'dart:math';
import 'package:flutter/material.dart';

class PremiumEffects extends StatefulWidget {

  final String emoji;

  const PremiumEffects({
    super.key,
    required this.emoji,
  });

  @override
  State<PremiumEffects> createState() =>
      _PremiumEffectsState();
}

class _PremiumEffectsState extends State<PremiumEffects>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  final Random random = Random();

  final List<_Particle> particles = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(

      vsync: this,

      duration: const Duration(seconds: 6),

    )..repeat();

    createParticles();

    controller.addListener(() {

      for (final p in particles) {

        p.y += p.speed;

        p.rotation += .01;

        if (p.y > 1.2) {

          p.y = -.15;

          p.x = random.nextDouble();

        }

      }

      if (mounted) {
        setState(() {});
      }

    });

  }

  void createParticles() {

    particles.clear();

    for (int i = 0; i < 60; i++) {

      particles.add(

        _Particle(

          x: random.nextDouble(),

          y: random.nextDouble(),

          size: 22 + random.nextDouble() * 18,

          speed: .002 + random.nextDouble() * .003,

        ),

      );

    }

  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final screen = MediaQuery.of(context).size;

    return IgnorePointer(

      child: Stack(

        children: [

          for (final p in particles)

            Positioned(

              left: p.x * screen.width,

              top: p.y * screen.height,

              child: Transform.rotate(

                angle: p.rotation,

                child: Text(

                  widget.emoji,

                  style: TextStyle(

                    fontSize: p.size,

                  ),

                ),

              ),

            ),

        ],

      ),

    );

  }

}

class _Particle {

  double x;

  double y;

  double size;

  double speed;

  double rotation = 0;

  _Particle({

    required this.x,

    required this.y,

    required this.size,

    required this.speed,

  });

}