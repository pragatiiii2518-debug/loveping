import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../love/our_story_screen.dart';
import '../love/journey_screen.dart';
import '../love/love_notes_screen.dart';
import '../love/playlist_screen.dart';
import '../love/open_when_screen.dart';
import '../love/bucket_list_screen.dart';
import '../love/late_night_thoughts_screen.dart';

import '../warning_screen.dart';

class LoveFeature {
  final String emoji;
  final String title;
  final String subtitle;
  final Widget screen;

  const LoveFeature({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.screen,
  });
}

class LoveTab extends StatelessWidget {
  const LoveTab({super.key});

  static const List<LoveFeature> features = [
    LoveFeature(
      emoji: "❤️",
      title: "Our Story",
      subtitle: "Write your beautiful love story together.",
      screen: OurStoryScreen(),
    ),

    LoveFeature(
      emoji: "💕",
      title: "Our Journey",
      subtitle: "Timeline of every special milestone.",
      screen: JourneyScreen(),
    ),

    LoveFeature(
      emoji: "🌸",
      title: "Love Notes",
      subtitle: "Cute sticky notes for each other.",
      screen: LoveNotesScreen(),
    ),

    LoveFeature(
      emoji: "🎵",
      title: "Our Playlist",
      subtitle: "Songs that remind you of each other.",
      screen: PlaylistScreen(),
    ),

    LoveFeature(
      emoji: "🎁",
      title: "Open When...",
      subtitle: "Letters to open for every emotion.",
      screen: OpenWhenScreen(),
    ),

    LoveFeature(
      emoji: "✨",
      title: "Future Bucket List",
      subtitle: "Dreams you'll complete together.",
      screen: BucketListScreen(),
    ),

    LoveFeature(
      emoji: "🌙",
      title: "Late Night Thoughts",
      subtitle: "Thoughts straight from the heart.",
      screen: LateNightThoughtsScreen(),
    ),

    LoveFeature(
      emoji: "⚠️",
      title: "WARNING!!",
      subtitle: "Open only if your love is forever.",
      screen: WarningScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffFFFDFE),
                    Color(0xffFFF2F8),
                    Color(0xffFFE6F2),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 80,
            left: 20,
            child: Icon(
              Icons.favorite,
              size: 90,
              color: Colors.pink.withOpacity(.05),
            ),
          ),

          Positioned(
            bottom: 120,
            right: 20,
            child: Icon(
              Icons.favorite,
              size: 120,
              color: Colors.pink.withOpacity(.05),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "❤️ Love",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Everything that tells your love story lives here.",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Expanded(
                                        child: ListView.builder(
                      itemCount: features.length,
                      itemBuilder: (context, index) {
                        final feature = features[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => feature.screen,
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 18,
                                  sigmaY: 18,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.45),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(.60),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.pink.withOpacity(.08),
                                        blurRadius: 18,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFFE0EC),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            feature.emoji,
                                            style: const TextStyle(
                                              fontSize: 34,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 18),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              feature.title,
                                              style:
                                                  GoogleFonts.poppins(
                                                fontSize: 19,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color:
                                                    const Color(0xffC2185B),
                                              ),
                                            ),

                                            const SizedBox(height: 6),

                                            Text(
                                              feature.subtitle,
                                              style:
                                                  GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black54,
                                                height: 1.5,
                                              ),
                                            ),
                                                                                      ],
                                        ),
                                      ),

                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xffC2185B),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  //--------------------------------------------------
                  // LOVE PROGRESS
                  //--------------------------------------------------

                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.45),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(.60),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(.08),
                          blurRadius: 18,
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "💕 Our Love Journey",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffC2185B),
                          ),
                        ),

                        const SizedBox(height: 14),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: LinearProgressIndicator(
                            value: .80,
                            minHeight: 12,
                            backgroundColor: Colors.pink.shade100,
                            valueColor:
                                const AlwaysStoppedAnimation(
                              Color(0xffE91E63),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Every memory, every smile and every promise makes your story even more beautiful ❤️",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                                                const SizedBox(height: 18),

                        Row(
                          children: [

                            Expanded(
                              child: _statCard(
                                "❤️",
                                "8",
                                "Chapters",
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _statCard(
                                "🌸",
                                "∞",
                                "Love",
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _statCard(
                                "✨",
                                "100%",
                                "Romance",
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 22),

                        Center(
                          child: Text(
                            "Every chapter begins with love ❤️",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xffC2185B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  ////////////////////////////////////////////////////////////
/// LOVE PROGRESS CARD
////////////////////////////////////////////////////////////

Widget _statCard(
  String emoji,
  String value,
  String title,
) {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 18,
    ),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.55),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: Colors.white.withOpacity(.65),
      ),
    ),
    child: Column(
      children: [

        Text(
          emoji,
          style: const TextStyle(
            fontSize: 28,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xffC2185B),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),

      ],
    ),
  );
}
}