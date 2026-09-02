import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'final_love_screen.dart';

class FinalHeart extends StatefulWidget {
  const FinalHeart({super.key});

  @override
  State<FinalHeart> createState() => _FinalHeartState();
}

class _FinalHeartState extends State<FinalHeart>
    with TickerProviderStateMixin {
  //--------------------------------------------------
  // CONTROLLERS
  //--------------------------------------------------

  late AnimationController _heartController;
  late AnimationController _glowController;
  late AnimationController _fadeController;

  //--------------------------------------------------
  // ANIMATIONS
  //--------------------------------------------------

  late Animation<double> _heartScale;
  late Animation<double> _glowScale;
  late Animation<double> _screenFade;

  bool _isOpening = false;

  @override
  void initState() {
    super.initState();

    //--------------------------------------------------
    // HEART BEAT
    //--------------------------------------------------

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);

    _heartScale = Tween<double>(
      begin: 1.0,
      end: 1.18,
    ).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: Curves.easeInOut,
      ),
    );

    //--------------------------------------------------
    // GLOW
    //--------------------------------------------------

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    _glowScale = Tween<double>(
      begin: .95,
      end: 1.22,
    ).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    //--------------------------------------------------
    // SCREEN FADE
    //--------------------------------------------------

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _screenFade = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    _glowController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  //--------------------------------------------------
  // HEART TAP
  //--------------------------------------------------

  Future<void> _openLove() async {
    if (_isOpening) return;

    _isOpening = true;

    _heartController.stop();
    _glowController.stop();

    await _fadeController.forward();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1200),
        pageBuilder: (_, __, ___) => const FinalLoveScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
    //--------------------------------------------------
  // UI
  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _screenFade,
        child: Stack(
          children: [

            //--------------------------------------------------
            // BACKGROUND
            //--------------------------------------------------

            Positioned.fill(
              child: Image.asset(
                "assets/images/use_this.jpg",
                fit: BoxFit.cover,
              ),
            ),

            //--------------------------------------------------
            // GLASS OVERLAY
            //--------------------------------------------------

            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 12,
                  sigmaY: 12,
                ),
                child: Container(
                  color: Colors.pink.withOpacity(.15),
                ),
              ),
            ),

            //--------------------------------------------------
            // FLOATING HEARTS
            //--------------------------------------------------

            Positioned(
              top: 70,
              left: 25,
              child: Icon(
                Icons.favorite,
                size: 90,
                color: Colors.white.withOpacity(.06),
              ),
            ),

            Positioned(
              top: 230,
              right: 20,
              child: Icon(
                Icons.favorite,
                size: 65,
                color: Colors.white.withOpacity(.05),
              ),
            ),

            Positioned(
              bottom: 120,
              left: 35,
              child: Icon(
                Icons.favorite,
                size: 110,
                color: Colors.white.withOpacity(.05),
              ),
            ),

            //--------------------------------------------------
            // CONTENT
            //--------------------------------------------------

            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [

                    const Spacer(),

                    Text(
                      "If you're strong enough...",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffC2185B),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      "Keep one hand on your heart\nand one hand on mine...😚",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 23,
                        color: Colors.black87,
                        height: 1.8,
                      ),
                    ),

                    const SizedBox(height: 60),

                    //--------------------------------------------------
                    // GLOW CIRCLE
                    //--------------------------------------------------

                    AnimatedBuilder(
                      animation: _glowScale,
                      builder: (_, child) {
                        return Transform.scale(
                          scale: _glowScale.value,
                          child: Container(
                            width: 210,
                            height: 210,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Colors.pink.withOpacity(.12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink
                                      .withOpacity(.28),
                                  blurRadius: 45,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: child,
                          ),
                        );
                      },

                      child: AnimatedBuilder(
  animation: _heartScale,
  builder: (_, child) {
    return Transform.scale(
      scale: _heartScale.value,
      child: GestureDetector(
        onTap: _openLove,

        child: Container(
          width: 130,
          height: 130,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            gradient: const RadialGradient(
              colors: [
                Color(0xffFFB3CF),
                Color(0xffFF6F9D),
                Color(0xffE91E63),
              ],
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(.45),
                blurRadius: 35,
                spreadRadius: 5,
              ),
            ],
          ),

          child: const Center(
            child: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 72,
            ),
          ),
        ),
      ),
    );
  },
),
                    ),

                    const SizedBox(height: 70),

                    Text(
                      "Tap the heart above ⬆️",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }