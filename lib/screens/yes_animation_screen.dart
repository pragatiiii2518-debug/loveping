import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'story_screen.dart';

class YesAnimationScreen extends StatefulWidget {
  const YesAnimationScreen({super.key});

  @override
  State<YesAnimationScreen> createState() =>
      _YesAnimationScreenState();
}

class _YesAnimationScreenState extends State<YesAnimationScreen>
    with SingleTickerProviderStateMixin {

  bool showText = false;

  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(
      vsync: this,
    );

    // Text appears almost immediately
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      setState(() {
        showText = true;
      });
    });

    // Go to Story Screen
    Future.delayed(const Duration(seconds: 9), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration:
              const Duration(milliseconds: 1800),
          pageBuilder: (_, animation, __) =>
              const StoryScreen(),
          transitionsBuilder:
              (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
  image: DecorationImage(
    image: AssetImage(
      "assets/images/yesno_bg.jpg",
    ),
    fit: BoxFit.cover,
  ),
),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),

            child: Transform.translate(
              offset: const Offset(0, -55),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  // Happy Girl Animation

                  Lottie.asset(
                    'assets/animations/happy_girl.json',
                    controller: _lottieController,
                    height: 285,
                    repeat: true,

                    onLoaded: (composition) {

                      _lottieController
                        ..duration =
                            composition.duration * 2
                        ..repeat();

                    },
                  ),

                  const SizedBox(height: 18),

                  AnimatedOpacity(
                    opacity: showText ? 1 : 0,
                    duration:
                        const Duration(milliseconds: 900),
                    curve: Curves.easeOut,

                    child: Column(
                      children: [
                                                Text(
                          "Whooo... ❤️",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xffC2185B),
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          "I knew you would\n"
                          "say YES! 🥰\n"
                          "You literally can't\n"
                          "say no to me!! 😘",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            height: 1.6,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff8E5A73),
                          ),
                        ),

                        const SizedBox(height: 28),

                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: .95, end: 1.08),
                          duration:
                              const Duration(milliseconds: 1400),
                          curve: Curves.easeInOut,

                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },

                          child: const Icon(
                            Icons.favorite,
                            color: Color(0xffFF6FAE),
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}