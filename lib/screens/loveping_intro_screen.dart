import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'features_screen.dart';

class LovePingIntroScreen extends StatefulWidget {
  const LovePingIntroScreen({super.key});

  @override
  State<LovePingIntroScreen> createState() =>
      _LovePingIntroScreenState();
}

class _LovePingIntroScreenState
    extends State<LovePingIntroScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
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
              "assets/images/ready_bg.png",
            ),

            fit: BoxFit.cover,

          ),

        ),

        child: SafeArea(

          child: Center(

            child: SingleChildScrollView(

              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),

              child: Column(

                children: [

                  const SizedBox(height: 5),

                  Lottie.asset(

                    "assets/animations/bears.json",

                    controller: _controller,

                    height: 230,

                    repeat: true,

                    onLoaded: (composition) {

                      _controller
                        ..duration = composition.duration
                        ..repeat();

                    },

                  ),

                  const SizedBox(height: 10),

                  Text(

                    "ATTENTION!!! 🤎",

                    style: GoogleFonts.playfairDisplay(

                      fontSize: 32,

                      fontWeight: FontWeight.bold,

                      color: const Color(0xff8B2F55),

                    ),

                  ),

                  const SizedBox(height: 22),

                  Container(

                    width: double.infinity,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 28,
                    ),

                    decoration: BoxDecoration(

                      color: Colors.white.withOpacity(.55),

                      borderRadius: BorderRadius.circular(34),

                      border: Border.all(
                        color: Colors.white70,
                      ),

                      boxShadow: [

                        BoxShadow(
                          color: Colors.pink.withOpacity(.12),
                          blurRadius: 18,
                        ),

                      ],

                    ),

                    child: Column(
                      children: [
                                                Text(
                          "LovePing isn't just another app... 💖",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffB5436F),
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          "It's our little world.\n"
                          "A place built specially for us,\n"
                          "where distance doesn't matter,\n"
                          "and every beautiful moment stays\n"
                          "forever.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff6D6469),
                            height: 1.7,
                          ),
                        ),

                        const SizedBox(height: 28),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [

                            _emojiItem(
                              "💬",
                              "Chats",
                            ),

                            _emojiItem(
                              "📸",
                              "Memories",
                            ),

                            _emojiItem(
                              "💌",
                              "Letters",
                            ),

                            _emojiItem(
                              "🎁",
                              "Surprises",
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
  width: double.infinity,
  height: 60,
  child: ElevatedButton(
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const FeaturesScreen(),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffF96D9D),
      elevation: 8,
      shadowColor: Colors.pink.withOpacity(.30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    child: Text(
      "Enter LovePing 💕",
      style: GoogleFonts.poppins(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
),

const SizedBox(height: 10),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //--------------------------------------------------
  // EMOJI ITEM
  //--------------------------------------------------

  Widget _emojiItem(
    String emoji,
    String title,
  ) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xff6D5E67),
          ),
        ),
      ],
    );
  }
}