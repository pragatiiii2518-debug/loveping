import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/ping/ping_background.dart';
import '../widgets/ping/ping_particles.dart';
import '../widgets/ping/ping_logo.dart';
import '../widgets/ping/last_sent_card.dart';
import '../widgets/ping/emoji_bottom_sheet.dart';

class PingScreen extends StatefulWidget {
  const PingScreen({super.key});

  @override
  State<PingScreen> createState() => _PingScreenState();
}

class _PingScreenState extends State<PingScreen> {
  String lastEmoji = "❤️";
  String lastMessage = "Nothing Yet";
  String lastTime = "--";

  // NEW
  bool _showSuccess = false;
  String _successEmoji = "❤️";

  Future<void> openEmojiPicker() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => EmojiBottomSheet(
        onEmojiSelected: (emoji) async {
       

          setState(() {
            lastEmoji = emoji;
            lastMessage = "You sent $emoji";
            lastTime = "Just now";

            _successEmoji = emoji;
            _showSuccess = true;
          });

          await Future.delayed(const Duration(seconds: 6));

          if (!mounted) return;

          setState(() {
            _showSuccess = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          //----------------------------------------------------
          // Premium Background
          //----------------------------------------------------

          const PingBackground(),

          //----------------------------------------------------
          // Floating Hearts
          //----------------------------------------------------

          const PingParticles(),
                    //----------------------------------------------------
          // Main UI
          //----------------------------------------------------

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              child: Column(
                children: [

                  //--------------------------------------------------
                  // BACK BUTTON
                  //--------------------------------------------------

                  Row(
                    children: [

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xffC2185B),
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            "LovePing",
                            style: GoogleFonts.greatVibes(
                              fontSize: 50,
                              color: const Color(0xffE91E63),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 48),

                    ],
                  ),

                  const SizedBox(height: 10),

                  const Spacer(),

                  //--------------------------------------------------
                  // LOGO
                  //--------------------------------------------------

                  PingLogo(
                    onTap: openEmojiPicker,
                  ),

                  const SizedBox(height: 40),

                  //--------------------------------------------------
                  // TITLE
                  //--------------------------------------------------

                  Text(
                    "Tap to Send\nYour Heartbeat ❤️",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade900,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Thinking about someone?\nSend them a heartbeat instantly.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),

                  const Spacer(),
                                    //--------------------------------------------------
                  // LAST SENT
                  //--------------------------------------------------

                  LastSentCard(
                    emoji: lastEmoji,
                    message: lastMessage,
                    time: lastTime,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          //----------------------------------------------------
          // SUCCESS POPUP (NEW)
          //----------------------------------------------------

          if (_showSuccess)
            Container(
              color: Colors.black.withOpacity(.22),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutBack,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 34,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(.22),
                        blurRadius: 30,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        _successEmoji,
                        style: const TextStyle(
                          fontSize: 62,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Heartbeat Sent!",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffE91E63),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Your love has been delivered ❤️",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
                    ],
      ),
    );
  }
}