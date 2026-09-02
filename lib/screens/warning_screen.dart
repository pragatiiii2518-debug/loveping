import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'final_heart.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          //--------------------------------------------------
          // BACKGROUND IMAGE
          //--------------------------------------------------

          Positioned.fill(
            child: Image.asset(
              "assets/images/use_this.jpg",
              fit: BoxFit.cover,
            ),
          ),

          //--------------------------------------------------
          // BLUR + PINK OVERLAY
          //--------------------------------------------------

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                color: Colors.pink.withOpacity(.18),
              ),
            ),
          ),

          //--------------------------------------------------
          // CONTENT
          //--------------------------------------------------

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 20,
                      sigmaY: 20,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.45),
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: Colors.white.withOpacity(.65),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(.15),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xffE91E63),
                            size: 70,
                          ),

                          const SizedBox(height: 22),

                          Text(
                            "WARNING !! ⚠️",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xffC2185B),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            "Are you really ready for this? Still there's a chance to think before you proceed... ",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            "Once you continue,\nthere's no going back...\nBecause this page holds\nsomething straight from my heart.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              color: Colors.black54,
                              height: 1.8,
                            ),
                          ),

                          const SizedBox(height: 35),

                          //--------------------------------------------------
                          // BUTTONS
                          //--------------------------------------------------

                          Row(
                            children: [

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const FinalHeart(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xffFF6F9D),
                                    foregroundColor: Colors.white,
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                  ),
                                  child: Text(
                                    " YES 💛 ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                    disabledBackgroundColor:
                                        Colors.grey.shade300,
                                    disabledForegroundColor:
                                        Colors.grey.shade500,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                  ),
                                  child: Text(
                                    "NO 💔",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          Text(
                            "Some feelings are too beautiful to turn away from. 🫶",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xffC2185B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}