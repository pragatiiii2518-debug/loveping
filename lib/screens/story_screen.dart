import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'loading_baccha_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {

  bool showLine1 = false;
  bool showLine2 = false;
  bool showLine3 = false;
  bool showLine4 = false;
  bool showButton = false;

  late AnimationController _buttonController;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    startAnimation();
  }

  Future<void> startAnimation() async {

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() {
      showLine1 = true;
    });

    await Future.delayed(const Duration(milliseconds: 2200));

    if (!mounted) return;

    setState(() {
      showLine2 = true;
    });

    await Future.delayed(const Duration(milliseconds: 2200));

    if (!mounted) return;

    setState(() {
      showLine3 = true;
    });

    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted) return;

    setState(() {
      showLine4 = true;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    setState(() {
      showButton = true;
    });
  }

  @override
  void dispose() {
    _buttonController.dispose();
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
      "assets/images/balloon_bg.png",
    ),
    fit: BoxFit.cover,
  ),
),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 20,
            ),

            child: Column(
              children: [

                const SizedBox(height: 20),

                // Birds Animation
                Lottie.asset(
                  'assets/animations/birds.json',
                  height: 220,
                  repeat: true,
                ),

                const SizedBox(height: 40),

                AnimatedOpacity(
                  opacity: showLine1 ? 1 : 0,
                  duration: const Duration(seconds: 2),
                  child: Text(
                    "Every Love Story...",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffC2185B),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                AnimatedOpacity(
                  opacity: showLine2 ? 1 : 0,
                  duration: const Duration(seconds: 2),
                  child: Text(
                    "deserves...",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff9C4D75),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                AnimatedOpacity(
                  opacity: showLine3 ? 1 : 0,
                  duration: const Duration(seconds: 2),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          Color(0xffFF5E9C),
                          Color(0xffFFC857),
                        ],
                      ).createShader(bounds);
                    },
                    child: Text(
                      "A Beautiful Beginning ❤️",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                                const SizedBox(height: 22),

                AnimatedOpacity(
                  opacity: showLine4 ? 1 : 0,
                  duration: const Duration(seconds: 2),
                  child: Text(
                    "Especially ours 🤞",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffC2185B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const Spacer(),

                AnimatedOpacity(
                  opacity: showButton ? 1 : 0,
                  duration: const Duration(seconds: 2),
                  child: AnimatedBuilder(
                    animation: _buttonController,
                    builder: (context, child) {
                      final scale =
                          1 + (_buttonController.value * .05);

                      return Transform.scale(
                        scale: scale,
                        child: SizedBox(
                          width: 290,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoadingBacchaScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xffFF5E9C),
                              foregroundColor: Colors.white,
                              elevation: 12,
                              shadowColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(35),
                              ),
                            ),
                            child: Text(
                              "Let's Begin ❤️",
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}