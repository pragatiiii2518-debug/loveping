import 'package:flutter/material.dart';

import '../widgets/animated_envelope.dart';
import '../widgets/flying_letter.dart';
import '../widgets/lottie_butterflies.dart';
import '../widgets/navigation_buttons.dart';

import 'loveping_intro_screen.dart';

class SurpriseScreen extends StatefulWidget {
  const SurpriseScreen({super.key});

  @override
  State<SurpriseScreen> createState() =>
      _SurpriseScreenState();
}

class _SurpriseScreenState
    extends State<SurpriseScreen> {

  //---------------------------------------------------------
  // STATES
  //---------------------------------------------------------

  bool showButterflies = false;

  bool showLetter = false;

  bool closeEnvelope = false;

  bool showButtons = false;

  //---------------------------------------------------------
  // LETTER POSITION
  //---------------------------------------------------------

  Offset letterPosition = const Offset(
    42,
    560,
  );

  //---------------------------------------------------------
  // START MAGIC
  //---------------------------------------------------------

  Future<void> startAnimation() async {

    //------------------------------------------------------
    // Butterfly Burst
    //------------------------------------------------------

    setState(() {
      showButterflies = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 900),
    );

    //------------------------------------------------------
    // Show Letter
    //------------------------------------------------------

    setState(() {

      showLetter = true;

      letterPosition = const Offset(
        42,
        560,
      );

    });

    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    //------------------------------------------------------
    // Lift Letter
    //------------------------------------------------------

    setState(() {

      letterPosition = const Offset(
        42,
        90,
      );

    });

    await Future.delayed(
      const Duration(milliseconds: 2600),
    );

    //------------------------------------------------------
    // Show Next Button
    //------------------------------------------------------

    setState(() {

      showButtons = true;

    });

  }

  //---------------------------------------------------------
  // CLOSE LETTER
  //---------------------------------------------------------

  Future<void> closeLoveLetter() async {

    setState(() {

      showButtons = false;

      letterPosition = const Offset(
        42,
        560,
      );

    });

    await Future.delayed(
      const Duration(milliseconds: 2200),
    );

    setState(() {

      showLetter = false;

      closeEnvelope = true;

    });

    await Future.delayed(
      const Duration(milliseconds: 900),
    );

    setState(() {

      showButterflies = false;

      closeEnvelope = false;

    });

  }
    //---------------------------------------------------------
  // BUILD
  //---------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(

        children: [

          //---------------------------------------------------------
          // BACKGROUND
          //---------------------------------------------------------

          Positioned.fill(

            child: Image.asset(

              "assets/images/theme_bg.png",

              fit: BoxFit.cover,

            ),

          ),

          //---------------------------------------------------------
          // BUTTERFLY BURST
          //---------------------------------------------------------

          LottieButterflies(

            visible: showButterflies,

          ),

          //---------------------------------------------------------
          // LETTER
          //---------------------------------------------------------

          FlyingLetter(

            visible: showLetter,

            position: letterPosition,

            onClose: closeLoveLetter,

          ),

          //---------------------------------------------------------
          // ENVELOPE
          //---------------------------------------------------------

          Positioned(

            bottom: 4,

            left: 0,

            right: 0,

            child: Center(

              child: AnimatedEnvelope(

                closeEnvelope: closeEnvelope,

                onOpened: startAnimation,

              ),

            ),

          ),
                    //---------------------------------------------------------
          // NAVIGATION BUTTONS
          //---------------------------------------------------------

          NavigationButtons(
            showNext: showButtons,

            onBack: () {
              Navigator.pop(context);
            },

            onNext: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LovePingIntroScreen(),
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}
