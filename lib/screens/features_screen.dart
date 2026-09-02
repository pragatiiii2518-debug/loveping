import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'love_hub_screen.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() =>
      _FeaturesScreenState();
}

class _FeaturesScreenState
    extends State<FeaturesScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //--------------------------------------------------
  // FEATURE INFO POPUP
  //--------------------------------------------------

  void _openFeature(int index) {

    const titles = [

      "Private Chats 💬",

      "Memories 📸",

      "Love Space ❤️",

      "LovePing 💓",

      "Profile 👤",

      "Secret Surprises 🎁",

    ];

    const descriptions = [

      "Chat privately with your partner in a secure and beautiful space. Every conversation stays between the two of you.",

      "Save your favourite photos and relive every beautiful memory together whenever you want.",

      "Store your love letters, playlists, special dates and romantic moments in one beautiful place.",

      "Send an instant heartbeat ❤️ to your partner with one tap and let them know you're thinking about them.",

      "Manage your Love ID, personalize your profile and keep your relationship connected securely.",

      "More romantic features, games and surprises will unlock in future updates.",

    ];

    showDialog(

      context: context,

      builder: (_) => Dialog(

        backgroundColor: Colors.transparent,

        child: Container(

          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(

            color: Colors.white.withOpacity(.96),

            borderRadius: BorderRadius.circular(30),

          ),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                titles[index],

                textAlign: TextAlign.center,

                style: GoogleFonts.poppins(

                  fontSize: 24,

                  fontWeight: FontWeight.bold,

                  color: const Color(0xffB03060),

                ),

              ),

              const SizedBox(height: 18),

              Text(

                descriptions[index],

                textAlign: TextAlign.center,

                style: GoogleFonts.poppins(

                  fontSize: 15,

                  height: 1.7,

                  color: const Color(0xff6D4C5B),

                ),

              ),

              const SizedBox(height: 24),

              SizedBox(

                width: 150,

                height: 48,

                child: ElevatedButton(

                  onPressed: () => Navigator.pop(context),

                  style: ElevatedButton.styleFrom(

                    backgroundColor: const Color(0xffFF7AA2),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(28),

                    ),

                  ),

                  child: Text(

                    "Got it ❤️",

                    style: GoogleFonts.poppins(

                      color: Colors.white,

                      fontWeight: FontWeight.w600,

                    ),

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 18,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),

                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeOut,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "✨ LovePing ✨",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffB03060),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Everything We Built\nTogether ❤️",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff7A3B69),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "Every memory, every heartbeat,\n"
                        "every smile and every little surprise\n"
                        "has a special place here.\n\n"
                        "Welcome to our little world 💕",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          height: 1.7,
                          color: const Color(0xff6D4C5B),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [

                      _featureCard(
                        emoji: "💬",
                        title: "Private Chats",
                        subtitle:
                            "Chat privately with your partner in one secure place.",
                        onTap: () => _openFeature(0),
                      ),

                      const SizedBox(height: 18),

                      _featureCard(
                        emoji: "📸",
                        title: "Memories",
                        subtitle:
                            "Save every beautiful photo and relive every special moment.",
                        onTap: () => _openFeature(1),
                      ),

                      const SizedBox(height: 18),

                      _featureCard(
                        emoji: "❤️",
                        title: "Love Space",
                        subtitle:
                            "Letters, playlists and romantic memories together.",
                        onTap: () => _openFeature(2),
                      ),

                      const SizedBox(height: 18),

                      _featureCard(
                        emoji: "💓",
                        title: "LovePing",
                        subtitle:
                            "Send an instant heartbeat with one tap.",
                        onTap: () => _openFeature(3),
                      ),

                      const SizedBox(height: 18),

                      _featureCard(
                        emoji: "👤",
                        title: "Profile",
                        subtitle:
                            "Manage your Love ID and personalize your account.",
                        onTap: () => _openFeature(4),
                      ),

                      const SizedBox(height: 18),

                      _featureCard(
                        emoji: "🎁",
                        title: "Secret Surprises",
                        subtitle:
                            "Exciting romantic features coming very soon.",
                        onTap: () => _openFeature(5),
                      ),

                      const SizedBox(height: 40),
                                            //--------------------------------------------------
                      // ENTER OUR WORLD BUTTON
                      //--------------------------------------------------

                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xffFF7AA2),
                            elevation: 8,
                            shadowColor:
                                Colors.pinkAccent.withOpacity(.40),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(35),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 700),
                                pageBuilder: (_, animation, __) =>
                                    const LoveHubScreen(),
                                transitionsBuilder:
                                    (_, animation, __, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            "❤️ Enter Our World",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //--------------------------------------------------
  // PREMIUM FEATURE CARD
  //--------------------------------------------------

  Widget _featureCard({
    required String emoji,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.60),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withOpacity(.45),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(.12),
              blurRadius: 18,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [

            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.75),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(
                    fontSize: 30,
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
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffB03060),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.5,
                      color: const Color(0xff6D4C5B),
                    ),
                  ),

                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xffB03060),
              size: 18,
            ),

          ],
        ),
      ),
    );
  }
  }