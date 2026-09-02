import 'dart:math';
import 'package:flutter/material.dart';

class PingParticles extends StatefulWidget {
  const PingParticles({super.key});

  @override
  State<PingParticles> createState() => _PingParticlesState();
}

class _PingParticlesState extends State<PingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final random = Random();

  final List<_Particle> particles = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..addListener(updateParticles)
      ..repeat();

    createParticles();
  }

  void createParticles() {
    particles.clear();

    for (int i = 0; i < 70; i++) {
      particles.add(
        _Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 18 + 10,
          speed: random.nextDouble() * .5 + .2,
          opacity: random.nextDouble() * .5 + .2,
          isHeart: random.nextBool(),
        ),
      );
    }
  }

  void updateParticles() {
    for (final p in particles) {
      p.y -= 0.0006 * p.speed;

      if (p.y < -0.1) {
        p.y = 1.1;
        p.x = random.nextDouble();
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return IgnorePointer(
      child: Stack(
        children: particles.map((p) {
          return Positioned(
            left: p.x * size.width,
            top: p.y * size.height,
            child: Opacity(
              opacity: p.opacity,
              child: p.isHeart
                  ? Icon(
                      Icons.favorite,
                      color: Colors.pinkAccent,
                      size: p.size,
                    )
                  : Container(
                      width: p.size / 3,
                      height: p.size / 3,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  bool isHeart;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.isHeart,
  });
}