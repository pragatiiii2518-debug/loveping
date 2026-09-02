import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'story_screen.dart';

class NoAnimationScreen extends StatefulWidget {
  const NoAnimationScreen({super.key});

  @override
  State<NoAnimationScreen> createState() =>
      _NoAnimationScreenState();
}

class _NoAnimationScreenState extends State<NoAnimationScreen>
    with SingleTickerProviderStateMixin {
  bool showText = false;

  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(
      vsync: this,
    );

    // Show text quickly
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        showText = true;
      });
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
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28),
              child: Transform.translate(
                offset: const Offset(0, -25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),

                    // Crying Animation
                    Lottie.asset(
                      'assets/animations/crying_girl.json',
                      controller: _lottieController,
                      height: 270,
                      repeat: true,
                      onLoaded: (composition) {
                        _lottieController
                          ..duration =
                              composition.duration * 2
                          ..repeat();
                      },
                    ),

                    const SizedBox(height: 20),

                    AnimatedOpacity(
                      opacity: showText ? 1 : 0,
                      duration:
                          const Duration(milliseconds: 900),
                      curve: Curves.easeOut,
                      child: Column(
                        children: [
                          Text(
                            "Seriouslllyyy...? 🥺",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xffC2185B),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            "I spent more than\n"
                            "15 days creating\n"
                            "this little surprise\n"
                            "just for you...",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              height: 1.6,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff8E5A73),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            "And you don't even\n"
                            "want to see it? 💔😭",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xffD81B60),
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: 310,
                            height: 58,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(
                                            seconds: 2),
                                    pageBuilder:
                                        (_, animation, __) =>
                                            const StoryScreen(),
                                    transitionsBuilder:
                                        (_, animation, __,
                                            child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xffFF6FAE),
                                elevation: 8,
                                shadowColor:
                                    Colors.pinkAccent,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          35),
                                ),
                              ),
                              child: Text(
                                "Okok bbyy gurll ❤️",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}