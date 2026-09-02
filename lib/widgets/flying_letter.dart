import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlyingLetter extends StatelessWidget {
  final bool visible;
  final Offset position;
  final VoidCallback onClose;

  const FlyingLetter({
    super.key,
    required this.visible,
    required this.position,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return AnimatedPositioned(
      duration: const Duration(seconds: 3),
      curve: Curves.easeInOutCubic,
      left: position.dx,
      top: position.dy,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 310,
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 32,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffFFF9EF),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xffE8D8B5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.18),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //-----------------------------------------
              // TITLE
              //-----------------------------------------

              Text(
                "To My Love ❤️",
                textAlign: TextAlign.center,
                style: GoogleFonts.greatVibes(
                  fontSize: 18,
                  color: const Color(0xff7A2E44),
                ),
              ),

              const SizedBox(height: 25),

              //-----------------------------------------
              // MESSAGE
              //-----------------------------------------

              Text(
                "I wish I could tell all the\n"
                "animals, birds,\n"
                "insects, butterflies,\n"
                "bugs, fishes,\n"
                "plants, trees,\n"
                "rivers, and mountains...\n"
                "that I have you by my side.\n"
                "I love you endlessly. ❤️",
                textAlign: TextAlign.center,
                style: GoogleFonts.greatVibes(
                  fontSize: 20,
                  color: const Color(0xFF4E342E),
                  height: 1.55,
                ),
              ),

              const SizedBox(height: 25),

              //-----------------------------------------
              // SIGNATURE
              //-----------------------------------------

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Yours Forever 💕",
                  style: GoogleFonts.greatVibes(
                    fontSize: 18,
                    color: const Color(0xffB3396B),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              //-----------------------------------------
              // CLOSE BUTTON
              //-----------------------------------------

              ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF8A7C2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Close Letter",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}