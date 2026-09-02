import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'heart_screen.dart';
import 'home_screen.dart';
import 'surprise_screen.dart';
import 'dart:math' as math;
class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _trainAnimation;

  late AnimationController _smokeController;
  late Animation<double> _smokeUp;
  late Animation<double> _smokeFade;
late AnimationController _starController;

  @override
  void initState() {
    super.initState();

    // TRAIN ANIMATION
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _trainAnimation = Tween<double>(
      begin: -500,
      end: 450,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    // SMOKE ANIMATION
    _smokeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _smokeUp = Tween<double>(
      begin: 0,
      end: -40,
    ).animate(
      CurvedAnimation(
        parent: _smokeController,
        curve: Curves.easeOut,
      ),
    );

    _smokeFade = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_smokeController);
    // STAR ANIMATION
_starController = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 2),
)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _smokeController.dispose();
    _starController.dispose();
    super.dispose();
  }
  Widget goldenStar(
    double left,
    double top,
    double size,
    double delay,
) {
  return AnimatedBuilder(
    animation: _starController,
    builder: (context, child) {
      final opacity =
          0.3 +
          0.7 *
              (0.5 +
                  0.5 *
                      math.sin(
                        (_starController.value + delay) * 2 * math.pi,
                      ));

      return Positioned(
        left: left,
        top: top,
        child: Opacity(
          opacity: opacity,
          child: Icon(
            Icons.auto_awesome,
            color: const Color(0xFFFFE082),
            size: size,
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// BACKGROUND
          Positioned.fill(
            child: Image.asset(
              "assets/images/quote_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          goldenStar(35, 70, 16, 0.1),
goldenStar(320, 60, 22, 0.4),
goldenStar(120, 140, 28, 0.8),
goldenStar(280, 190, 24, 0.3),
goldenStar(70, 280, 26, 0.6),
goldenStar(330, 330, 22, 0.9),
goldenStar(170, 230, 25, 0.5),

          /// MOVING TRAIN
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {

              // Tiny train bounce
              final bounce =
                  2 * (1 - ((_controller.value * 10) % 1 - 0.5).abs() * 2);

              return Positioned(
                top: 50 + bounce,
                left: _trainAnimation.value,
                child: SizedBox(
                  width: 500,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [

                      /// TRAIN
                      Image.asset(
                        "assets/images/train.png",
                        width: 500,
                      ),

                      /// SMOKE
                      AnimatedBuilder(
                        animation: _smokeController,
                        builder: (context, child) {
                          return Positioned(
                            left: 305,
                            top: _smokeUp.value + 8,
                            child: Opacity(
                              opacity: _smokeFade.value,
                              child: Transform.scale(
                                scale:
                                    0.25 + (_smokeController.value * 0.35),
                                child: Image.asset(
                                  "assets/images/smoke.png",
                                  width: 60,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          /// GLOWING GOLD BUTTON
          Align(
            alignment: const Alignment(0, 0.87),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD86B).withOpacity(.60),
                    blurRadius: 30,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: SizedBox(
                width: 315,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HeartScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA8CFA8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Text(
                    "Please Board the Train🚂",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5B3A00),
                      letterSpacing: .4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}