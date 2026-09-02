import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LastSentCard extends StatelessWidget {
  final String emoji;
  final String message;
  final String time;

  const LastSentCard({
    super.key,
    required this.emoji,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: Colors.white.withOpacity(.20),
        ),
      ),

      child: Row(
        children: [

          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 26),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Last Ping",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF6D3A7C),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  message,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF6D3A7C),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          Text(
            time,
            style: GoogleFonts.poppins(
              color: const Color(0xFF6D3A7C),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}