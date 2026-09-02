import 'dart:math';
import 'package:flutter/material.dart';

class FloatingEmojiAnimation extends StatefulWidget {

  final String emoji;

  const FloatingEmojiAnimation({
    super.key,
    required this.emoji,
  });

  @override
  State<FloatingEmojiAnimation> createState() =>
      _FloatingEmojiAnimationState();
}

class _FloatingEmojiAnimationState
    extends State<FloatingEmojiAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  final Random random = Random();

  final List<_FloatingEmoji> emojis = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(

      vsync: this,

      duration: const Duration(seconds: 5),

    )..repeat();

    createEmojis();

    controller.addListener(() {

      for (final e in emojis) {

        e.y -= e.speed;

        if (e.y < -.15) {

          e.y = 1.15;

          e.x = random.nextDouble();

        }

      }

      if (mounted) {

        setState(() {});

      }

    });

  }

  void createEmojis() {

    emojis.clear();

    for (int i = 0; i < 100; i++) {

      emojis.add(

        _FloatingEmoji(

          x: random.nextDouble(),

          y: random.nextDouble(),

          size: 22 + random.nextDouble() * 18,

          speed: .002 + random.nextDouble() * .004,

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

          for (final e in emojis)

            Positioned(

              left: e.x * screen.width,

              top: e.y * screen.height,

              child: Text(

                widget.emoji,

                style: TextStyle(

                  fontSize: e.size,

                ),

              ),

            ),

        ],

      ),

    );

  }

}

class _FloatingEmoji {

  double x;

  double y;

  double size;

  double speed;

  _FloatingEmoji({

    required this.x,

    required this.y,

    required this.size,

    required this.speed,

  });

}