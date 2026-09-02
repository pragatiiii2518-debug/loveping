import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmojiBottomSheet extends StatelessWidget {
  final Function(String) onEmojiSelected;

  const EmojiBottomSheet({
    super.key,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    final romantic = [
      "❤️",
      "💕",
      "💖",
      "💘",
      "💝",
      "🥰",
      "😘",
      "😍",
      "🌹",
      "💋",
      "🫶",
      "💍",
    ];

    final emotions = [
      "😊",
      "🥺",
      "😭",
      "😂",
      "🥹",
      "🤗",
      "🤭",
      "😚",
      "😇",
      "🥳",
      "😌",
      "🙈",
    ];

    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(35),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 25,
            sigmaY: 25,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height * .82,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.92),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(35),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                22,
                18,
                22,
                28,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  //--------------------------------

                  Center(
                    child: Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Send Love ❤️",
                    style:
                        GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color:
                          const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Choose the perfect emotion",
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _title("Romantic"),

                  const SizedBox(height: 16),

                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: romantic.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemBuilder: (_, i) =>
                        _emojiCard(
                      context,
                      romantic[i],
                    ),
                  ),

                  const SizedBox(height: 28),

                  _title("Emotions"),

                  const SizedBox(height: 16),

                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: emotions.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemBuilder: (_, i) =>
                        _emojiCard(
                      context,
                      emotions[i],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Text(
                      "More categories coming soon ❤️",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: const Color(0xffC2185B),
      ),
    );
  }

  Widget _emojiCard(
      BuildContext context,
      String emoji,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.pop(context);
        onEmojiSelected(emoji);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: const Color(0xffFFF0F6),
          borderRadius:
              BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(.10),
              blurRadius: 12,
            ),
          ],
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(
              fontSize: 34,
            ),
          ),
        ),
      ),
    );
  }
}