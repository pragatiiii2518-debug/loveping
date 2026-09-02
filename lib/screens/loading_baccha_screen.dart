import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'quote_screen.dart';

class LoadingBacchaScreen extends StatefulWidget {
  const LoadingBacchaScreen({super.key});

  @override
  State<LoadingBacchaScreen> createState() =>
      _LoadingBacchaScreenState();
}

class _LoadingBacchaScreenState
    extends State<LoadingBacchaScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _heartController;

  final Random random = Random();

  final List<_Heart> hearts = [];

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )
      ..addListener(_updateHearts)
      ..repeat();

    _generateHearts();

    Future.delayed(
      const Duration(seconds: 11),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const QuoteScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  //--------------------------------------------------
  // HEARTS
  //--------------------------------------------------

  void _generateHearts() {

    hearts.clear();

    for (int i = 0; i < 24; i++) {

      hearts.add(

        _Heart(

          x: random.nextDouble(),

          y: random.nextDouble(),

          speed: .0005 +
              random.nextDouble() * .0008,

          size: 8 +
              random.nextDouble() * 12,

          opacity: .25 +
              random.nextDouble() * .45,

        ),

      );

    }

  }

  void _updateHearts() {

    for (final h in hearts) {

      h.y -= h.speed;

      h.x += sin(h.y * 18) * .0008;

      if (h.y < -0.08) {

        h.y = 1.05;

        h.x = random.nextDouble();

      }

    }

    if (mounted) {
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {

    final screen = MediaQuery.of(context).size;

    return Scaffold(

      body: Stack(

        children: [

          //--------------------------------------------------
          // BACKGROUND
          //--------------------------------------------------

          Positioned.fill(

            child: Image.asset(

              "assets/images/balloon_bg.png",

              fit: BoxFit.cover,

            ),

          ),

         
                    //--------------------------------------------------
          // FLOATING HEARTS
          //--------------------------------------------------

          ...hearts.map((heart) {

            return Positioned(

              left: heart.x * screen.width,

              top: heart.y * screen.height,

              child: Opacity(

                opacity: heart.opacity,

                child: Icon(

                  Icons.favorite,

                  color: const Color(0xffFF77AA),

                  size: heart.size,

                ),

              ),

            );

          }).toList(),

          //--------------------------------------------------
          // CENTER CONTENT
          //--------------------------------------------------

          Center(

            child: Column(

              mainAxisSize: MainAxisSize.min,

              children: [

                const Text(

                  "🤗",

                  style: TextStyle(
                    fontSize: 80,
                  ),

                ),

                const SizedBox(height: 22),

                Text(

                  "Loadingg Bacchhaaa 💗",

                  textAlign: TextAlign.center,

                  style: GoogleFonts.playfairDisplay(

                    fontSize: 33,

                    fontWeight: FontWeight.bold,

                    color: const Color(0xffA81D63),

                  ),

                ),

                const SizedBox(height: 28),

                const SizedBox(

                  width: 40,

                  height: 40,

                  child: CircularProgressIndicator(

                    strokeWidth: 4,

                    valueColor: AlwaysStoppedAnimation(
                      Color(0xffFF4F93),
                    ),

                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }
  } // <-- END OF _LoadingBacchaScreenState



//--------------------------------------------------
// HEART MODEL
//--------------------------------------------------

class _Heart {

  double x;
  double y;

  double speed;

  double size;

  double opacity;

  _Heart({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });

}