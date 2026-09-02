import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'surprise_screen.dart';

class HeartScreen extends StatefulWidget {
  const HeartScreen({super.key});

  @override
  State<HeartScreen> createState() => _HeartScreenState();
}

class _HeartScreenState extends State<HeartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(vsync: this);

    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SurpriseScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
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
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [

                    // ❤️ Fast Glowing Heart
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent
                                .withOpacity(.35),
                            blurRadius: 60,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                      child: Lottie.asset(
                        "assets/animations/excited_heart.json",
                        controller: _heartController,
                        height: 315,
                        repeat: true,
                        onLoaded: (composition) {
                          _heartController
                            // Faster than before
                            ..duration =
                                composition.duration * 0.7
                            ..repeat();
                        },
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Glassmorphism Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.55),
                        borderRadius:
                            BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white70,
                          width: 1.3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.pink.withOpacity(.15),
                            blurRadius: 25,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                                                    Text(
                            "On My Way",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xffB03060),
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "To Win",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xffC85A8E),
                            ),
                          ),

                          const SizedBox(height: 10),

                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  Color(0xffFF4F8B),
                                  Color(0xffFF7AA2),
                                  Color(0xffE83E8C),
                                ],
                              ).createShader(bounds);
                            },
                            child: Text(
                              "Your Little\nHeart ❤️",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 46,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.15,
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          Text(
                            "Just wait a little...\nSomething magical is coming ✨",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff6D4C5B),
                              height: 1.6,
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
      ),
    );
  }
}