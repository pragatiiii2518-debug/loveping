import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'yes_animation_screen.dart';
import 'no_animation_screen.dart';
import 'love_hub_screen.dart';

class LoveWelcomeScreen extends StatefulWidget {
  const LoveWelcomeScreen({super.key});

  @override
  State<LoveWelcomeScreen> createState() =>
      _LoveWelcomeScreenState();
}

class _LoveWelcomeScreenState
    extends State<LoveWelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _heartController;
  late AnimationController _buttonController;
  late AnimationController _loadingController;

  bool showLoading = true;
  bool showWelcome = false;
  bool showQuestion = false;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    startAnimation();
  }

  Future<void> startAnimation() async {
    await Future.delayed(
      const Duration(seconds: 8),
    );

    if (!mounted) return;

    setState(() {
      showLoading = false;
      showWelcome = true;
    });

    await Future.delayed(
      const Duration(seconds: 5),
    );

    if (!mounted) return;

    setState(() {
      showWelcome = false;
      showQuestion = true;
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _heartController.dispose();
    _buttonController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  //==========================
  // Floating Hearts
  //==========================

  Widget floatingHeart(
    double left,
    double top,
    double size,
    double opacity,
    double delay,
  ) {
    return AnimatedBuilder(
      animation: _heartController,
      builder: (_, __) {
        final value =
            (_heartController.value + delay) % 1;

        return Positioned(
          left: left,
          top: top - value * 90,
          child: Opacity(
            opacity: opacity * (1 - value),
            child: Icon(
              Icons.favorite,
              color: const Color(0xffFF6FAE),
              size: size,
            ),
          ),
        );
      },
    );
  }

  //==========================
  // Sparkles
  //==========================

  Widget sparkle(
    double left,
    double top,
    double size,
    double delay,
  ) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (_, __) {
        final scale = .8 +
            .3 *
                math.sin(
                  (_backgroundController.value +
                          delay) *
                      math.pi *
                      2,
                );

        return Positioned(
          left: left,
          top: top,
          child: Transform.scale(
            scale: scale,
            child: Icon(
              Icons.auto_awesome,
              color: const Color(0xffFFD166),
              size: size,
            ),
          ),
        );
      },
    );
  }

  //==========================
  // Loading Screen
  //==========================

  Widget loadingWidget() {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xffFF5E9C),
                Color(0xffFFC857),
              ],
            ).createShader(bounds);
          },
          child: const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 90,
          ),
        ),

        const SizedBox(height: 25),

        Text(
          "Loading Love...",
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: const Color(0xffFF4F8B),
          ),
        ),

        const SizedBox(height: 22),

        SizedBox(
          width: 240,
          child: AnimatedBuilder(
            animation: _loadingController,
            builder: (_, __) {
              return LinearProgressIndicator(
                value: _loadingController.value,
                minHeight: 8,
                borderRadius:
                    BorderRadius.circular(30),
                backgroundColor:
                    Colors.white30,
                valueColor:
                    const AlwaysStoppedAnimation(
                  Color(0xffFF5E9C),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  //==================================================
// WELCOME SCREEN
//==================================================

Widget welcomeWidget() {
  return AnimatedOpacity(
    duration: const Duration(milliseconds: 1800),
    opacity: showWelcome ? 1 : 0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: .8, end: 1),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Text(
            "Welcome to LovePing",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: const Color(0xffC2185B),
              height: 1.15,
            ),
          ),
        ),

        const SizedBox(height: 28),

        Text(
          "The only platform\n"
          "to love each other digitally.",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: const Color(0xffA85F82),
            height: 1.6,
          ),
        ),

        const SizedBox(height: 55),

        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: .9, end: 1.1),
          curve: Curves.easeInOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xffFF5E9C),
                      Color(0xffFFC857),
                    ],
                  ).createShader(bounds);
                },
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 35),

        Text(
          "Made with ❤️",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xffFF1493),
          ),
        ),
      ],
    ),
  );
}

//==================================================
// QUESTION SCREEN
//==================================================

Widget questionWidget() {
  return AnimatedOpacity(
    duration: const Duration(milliseconds: 1500),
    opacity: showQuestion ? 1 : 0,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.28),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: Colors.white.withOpacity(.55),
                width: 2,
              ),
            ),
            child: Column(
              children: [

                const Icon(
                  Icons.card_giftcard,
                  size: 48,
                  color: Color(0xffFF5E9C),
                ),

                const SizedBox(height: 18),

                Text(
                  "Are you ready to see\n"
                  "the little surprise\n"
                  "I created just for you?\n\n"
                  "🎁😁",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                    color: const Color(0xff9D4F6B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 45),

          //-------------------------------------------------
          // YES BUTTON
          //-------------------------------------------------

          AnimatedBuilder(
            animation: _buttonController,
            builder: (_, child) {
              final scale =
                  1 + (_buttonController.value * .04);

              return Transform.scale(
                scale: scale,
                child: SizedBox(
                  width: 300,
                  height: 62,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const YesAnimationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xffFFBE55),
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      "YES, SHOW ME ❤️",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          //-------------------------------------------------
          // NO BUTTON
          //-------------------------------------------------

          SizedBox(
            width: 300,
            height: 62,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const NoAnimationScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor:
                    Colors.white.withOpacity(.18),
                side: const BorderSide(
                  color: Color(0xffFF80AB),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(40),
                ),
              ),
              child: Text(
                "NO, NOT NOW 🙈",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffD94F7A),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          //-------------------------------------------------
          // SKIP TO CHAT
          //-------------------------------------------------

          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LoveHubScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.chat_bubble_rounded,
              color: Color(0xffC2185B),
            ),
            label: Text(
              "Skip to Chat",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xffC2185B),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Text(
            "Made with ❤️ just for you",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: const Color(0xffB96E8D),
            ),
          ),
        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xffFFE5F1),
                    const Color(0xffF8E6FF),
                    _backgroundController.value,
                  )!,
                  Color.lerp(
                    const Color(0xffFFF2D8),
                    const Color(0xffFFE8F4),
                    _backgroundController.value,
                  )!,
                  Color.lerp(
                    const Color(0xffFFF9FC),
                    const Color(0xffFFF2F8),
                    _backgroundController.value,
                  )!,
                ],
              ),
            ),

            child: Stack(
              children: [

                //------------------------------------
                // Top Glow
                //------------------------------------

                Positioned(
                  top: -120,
                  left: -100,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.25),
                    ),
                  ),
                ),

                //------------------------------------
                // Bottom Glow
                //------------------------------------

                Positioned(
                  bottom: -140,
                  right: -120,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xffFFB7D5)
                          .withOpacity(.18),
                    ),
                  ),
                ),

                //------------------------------------
                // Floating Hearts
                //------------------------------------

                floatingHeart(30, 180, 22, .7, 0),
                floatingHeart(320, 120, 18, .6, .2),
                floatingHeart(60, 360, 25, .6, .4),
                floatingHeart(330, 520, 18, .5, .6),
                floatingHeart(80, 700, 26, .5, .8),
                floatingHeart(290, 780, 20, .5, .3),
                floatingHeart(170, 580, 16, .4, .5),
                floatingHeart(240, 260, 22, .6, .1),

                //------------------------------------
                // Sparkles
                //------------------------------------

                sparkle(40, 80, 18, 0),
                sparkle(300, 150, 16, .3),
                sparkle(260, 360, 15, .5),
                sparkle(70, 580, 18, .7),
                sparkle(220, 760, 16, .2),
                sparkle(150, 250, 20, .4),
                sparkle(290, 480, 16, .8),
                sparkle(110, 430, 14, .6),

                //------------------------------------
                // Back Button
                //------------------------------------

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.maybePop(context);
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.35),
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(.6),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xffC2185B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //------------------------------------
                // Screen Switcher
                //------------------------------------

                Center(
                  child: AnimatedSwitcher(
                    duration:
                        const Duration(milliseconds: 1200),
                    child: showLoading
                        ? loadingWidget()
                        : showWelcome
                            ? welcomeWidget()
                            : questionWidget(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
