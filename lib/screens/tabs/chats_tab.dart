import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        //--------------------------------------------------
        // BEAUTIFUL BACKGROUND
        //--------------------------------------------------

        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffFFFDFE),
                  Color(0xffFFF3F8),
                  Color(0xffFFE7F2),
                ],
              ),
            ),
          ),
        ),

        //--------------------------------------------------
        // FLOATING HEARTS
        //--------------------------------------------------

        Positioned(
          top: 60,
          left: 25,
          child: Icon(
            Icons.favorite,
            size: 90,
            color: Colors.pink.withOpacity(.06),
          ),
        ),

        Positioned(
          top: 220,
          right: 20,
          child: Icon(
            Icons.favorite,
            size: 70,
            color: Colors.pink.withOpacity(.05),
          ),
        ),

        Positioned(
          bottom: 80,
          left: 30,
          child: Icon(
            Icons.favorite,
            size: 110,
            color: Colors.pink.withOpacity(.05),
          ),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //--------------------------------------------------
                // HEADER
                //--------------------------------------------------

                Row(
                  children: [


                    

                    Text(
                      "💬 Chats",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffC2185B),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  "Private conversations with the one who means the most.",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),
                                //--------------------------------------------------
                // CONNECT PARTNER CARD
                //--------------------------------------------------

                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 18,
                      sigmaY: 18,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.45),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(.60),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(.08),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [

                          Container(
                            width: 82,
                            height: 82,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xffFFE0EC),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(.20),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              size: 42,
                              color: Color(0xffE91E63),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            "No Partner Connected",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xffC2185B),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Connect with your special person using your Love ID to unlock private chats.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black54,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: 230,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: () {},

                              icon: const Icon(Icons.favorite),

                              label: Text(
                                "Connect Partner",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffFF6F9D),
                                foregroundColor: Colors.white,
                                elevation: 6,
                                shadowColor:
                                    Colors.pink.withOpacity(.35),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),
                                //--------------------------------------------------
                // PRIVATE CHAT INFO
                //--------------------------------------------------

                ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 16,
                      sigmaY: 16,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.40),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: Colors.white.withOpacity(.55),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(.08),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: Color(0xffFFE2EE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              color: Color(0xffE91E63),
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "Private & Secure",
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color(0xffC2185B),
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "Your conversations stay between you and your partner only. Every heartbeat, every message and every memory is yours forever.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.black54,
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

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }
}