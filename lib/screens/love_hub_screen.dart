import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ping_screen.dart';

import 'tabs/chats_tab.dart';
import 'tabs/love_tab.dart';
import 'tabs/memories_tab.dart';
import 'tabs/profile_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class LoveHubScreen extends StatefulWidget {
  const LoveHubScreen({super.key});

  @override
  State<LoveHubScreen> createState() => _LoveHubScreenState();
}

class _LoveHubScreenState extends State<LoveHubScreen>
    with TickerProviderStateMixin {

  int currentIndex = 0;
  final FirestoreService firestoreService = FirestoreService();

String hearts = "0";
String streak = "0";
String letters = "0";

bool loadingStats = true;

  late AnimationController _logoController;
  late Animation<double> _logoScale;

  late AnimationController _heartController;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(
      begin: .96,
      end: 1.04,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    pages = const [
      ChatsTab(),
      MemoriesTab(),
      LoveTab(),
      ProfileTab(),
    ];
    loadStats();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _heartController.dispose();
    super.dispose();
  }
Future<void> loadStats() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final data = await firestoreService.getUserData(user.uid);

  setState(() {
    hearts = (data["hearts"] ?? 0).toString();
    streak = (data["streak"] ?? 0).toString();
    letters = (data["letters"] ?? 0).toString();
    loadingStats = false;
  });
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: Stack(

        children: [

          //----------------------------------------------------
          // ORIGINAL PHOTO
          //----------------------------------------------------

          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(1, 0),
              child: Image.asset(
                "assets/images/uss.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ),

          //----------------------------------------------------
          // VERY LIGHT WHITE FADE
          //----------------------------------------------------

         Positioned.fill(
  child: Container(
    color: Colors.white.withOpacity(.53),
  ),
),

          //----------------------------------------------------
          // SMALL FLOATING HEARTS
          //----------------------------------------------------

          AnimatedBuilder(
            animation: _heartController,
            builder: (_, __) {

              return Stack(
                children: List.generate(10, (i) {

                  final x = (i * 42.0) % 360;
                  final y = (i * 120.0) % 760;

                  return Positioned(
                    left: x,
                    top: y +
                        math.sin(
                              (_heartController.value * 2 * math.pi) + i,
                            ) *
                            6,
                    child: Icon(
                      Icons.favorite,
                      size: 10,
                      color: Colors.pink.withOpacity(.14),
                    ),
                  );
                }),
              );
            },
          ),

          //----------------------------------------------------
          // BODY
          //----------------------------------------------------

          SafeArea(
            child: currentIndex == 0
                ? _homeBody(context)
                : pages[currentIndex - 1],
          ),
        ],
      ),

      bottomNavigationBar: _bottomNavigation(),
    );
  }
  //----------------------------------------------------
// HOME BODY
//----------------------------------------------------

Widget _homeBody(BuildContext context) {

  return SingleChildScrollView(

    padding: const EdgeInsets.fromLTRB(
      24,
      8,
      24,
      30,
    ),

    child: Column(

      children: [

        //------------------------------------------------
        // APP TITLE
        //------------------------------------------------

        Text(
          "✨ LovePing ✨",
          style: GoogleFonts.poppins(
            fontSize: 44,
            fontWeight: FontWeight.w800,
            color: const Color(0xffC2185B),
            letterSpacing: .5,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          "Every heartbeat finds its way 💗",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF9C4F72),
          ),
        ),

        const SizedBox(height: 4),

        //------------------------------------------------
        // LOVEPING LOGO
        //------------------------------------------------

        GestureDetector(

          onTap: () {

            Navigator.push(

              context,

              MaterialPageRoute(
                builder: (_) => const PingScreen(),
              ),

            );

          },

          child: AnimatedBuilder(

            animation: _logoScale,

            builder: (_, __) {

              return Transform.scale(

                scale: _logoScale.value,

                child: Stack(

                  alignment: Alignment.center,

                  children: [

                    //----------------------------------
                    // SOFT GLOW ONLY BEHIND LOGO
                    //----------------------------------

                    Container(

                      width: 250,
                      height: 250,

                      decoration: BoxDecoration(

                        shape: BoxShape.circle,

                        boxShadow: [

                          BoxShadow(

                            color: Colors.pink.withOpacity(.20),

                            blurRadius: 45,

                            spreadRadius: 4,

                          ),

                        ],

                      ),

                    ),

                    //----------------------------------
                    // LOGO
                    //----------------------------------

                    Hero(

                      tag: "loveping_logo",

                      child: Image.asset(

                        "assets/images/ping_logo.png",

                        width: 300,

                        fit: BoxFit.contain,

                      ),

                    ),

                  ],

                ),

              );

            },

          ),

        ),

        //------------------------------------------------
        // JUST BELOW LOGO
        //------------------------------------------------

        const SizedBox(height: 0),
ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: BackdropFilter(
    filter: ImageFilter.blur(
      sigmaX: 15,
      sigmaY: 15,
    ),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0EC).withOpacity(.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(.45),
        ),
      ),
      child: Column(
        children: [
          Text(
            "Tap the Heart to Send Love 🩷",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFC2185B),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "One heartbeat can brighten someone's day.\nSend love instantly with a single tap 😉",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 17,
              height: 1.6,
              color: const Color(0xFF6D3A7C),
            ),
          ),
        ],
      ),
    ),
  ),
),
                //------------------------------------------------
        // CONNECT PARTNER CARD
        //------------------------------------------------

        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 16,
              sigmaY: 16,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.45),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(.65),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
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
                      color: const Color(0xffFFE4EF),
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Color(0xffE91E63),
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Waiting for Your Person 💕",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffB0004D),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Connect with your soulmate using your Love ID and unlock your private love world.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.6,
                      color: const Color(0xFF9C4F72),
                    ),
                  ),

                  const SizedBox(height: 22),

                 SizedBox(
  width: 235,
  height: 52,
  child: ElevatedButton.icon(
    onPressed: () {
      showDialog(
        context: context,
        builder: (dialogContext) {
          final controller = TextEditingController();

          return AlertDialog(
            title: const Text("Connect Partner 💕"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter Love ID",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  print(
                    "Partner Love ID: ${controller.text.trim()}",
                  );
                  Navigator.pop(dialogContext);
                },
                child: const Text("Connect"),
              ),
            ],
          );
        },
      );
    },
    icon: const Icon(Icons.favorite),
    label: Text(
      "Connect Partner",
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffFF5E95),
      foregroundColor: Colors.white,
      elevation: 6,
      shadowColor: Colors.pink.withOpacity(.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    ),
  ),
),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        //------------------------------------------------
        // LOVE STATS
        //------------------------------------------------

        //------------------------------------------------
        // LOVE STATS
        //------------------------------------------------

        Row(
          children: [

            Expanded(
              child: _loveStatCard(
  emoji: "❤️",
  value: loadingStats ? "..." : hearts,
  title: "Hearts",
),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _loveStatCard(
  emoji: "🔥",
  value: loadingStats ? "..." : streak,
  title: "Streak",
),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _loveStatCard(
  emoji: "💌",
  value: loadingStats ? "..." : letters,
  title: "Letters",
),
            ),

          ],
        ),

        const SizedBox(height: 26),
                //------------------------------------------------
        // QUICK ACTION CARD
        //------------------------------------------------

        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 16,
              sigmaY: 16,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.42),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(.65),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [

                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffFFE3EF),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Color(0xffE91E63),
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Text(
                      "Tap the glowing LovePing logo above to instantly send a heartbeat ❤️",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6D3A7C),
                        height: 1.6,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 36),

      ],
    ),
  );
}

//////////////////////////////////////////////////////////
// LOVE STAT CARD
//////////////////////////////////////////////////////////

Widget _loveStatCard({
  required String emoji,
  required String value,
  required String title,
}) {

  return Container(

    padding: const EdgeInsets.symmetric(
      vertical: 22,
    ),

    decoration: BoxDecoration(

      color: Colors.white.withOpacity(.48),

      borderRadius: BorderRadius.circular(22),

      border: Border.all(
        color: Colors.white.withOpacity(.65),
      ),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.03),
          blurRadius: 14,
        ),
      ],

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
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: const Color(0xffB0004D),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: const Color(0xFF6D3A7C),
          ),
        ),

      ],
    ),
  );
}

//------------------------------------------------
// PREMIUM BOTTOM NAVIGATION
//------------------------------------------------

Widget _bottomNavigation() {

  return Container(

    margin: const EdgeInsets.fromLTRB(
      18,
      0,
      18,
      18,
    ),

    decoration: BoxDecoration(

      color: Colors.white.withOpacity(.78),

      borderRadius: BorderRadius.circular(34),

      boxShadow: [

        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 25,
          offset: const Offset(0, 10),
        ),

      ],

    ),

    child: ClipRRect(

      borderRadius: BorderRadius.circular(34),

      child: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {

            currentIndex = index;

          });

        },

        backgroundColor: Colors.transparent,

        elevation: 0,

        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xffE91E63),

        unselectedItemColor: Colors.grey.shade600,

        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),

        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 10,
        ),

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: "Chats",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library_rounded),
            label: "Moments",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_rounded),
            activeIcon: Icon(Icons.favorite_rounded),
            label: "Love",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: "Profile",
          ),

        ],

      ),

    ),

  );

}

}