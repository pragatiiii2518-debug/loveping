import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'love_hub_screen.dart';

class FinalLoveScreen extends StatefulWidget {
  const FinalLoveScreen({super.key});

  @override
  State<FinalLoveScreen> createState() => _FinalLoveScreenState();
}

class _FinalLoveScreenState extends State<FinalLoveScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController teddyController;

  @override
  void initState() {
    super.initState();

    teddyController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    teddyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffFFF7F8),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18,
          ),

          child: Column(

            children: [

              //----------------------------------
              // BACK BUTTON
              //----------------------------------

              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xffE58AA8),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //----------------------------------
              // TEDDY
              //----------------------------------

              SizedBox(
                width: 165,
                height: 165,
                child: Lottie.asset(
                  "assets/animations/teddy_bear.json",
                  controller: teddyController,
                  repeat: true,
                  onLoaded: (composition) {
                    teddyController.duration =
                        composition.duration;
                    teddyController.forward();
                  },
                ),
              ),

              const SizedBox(height: 18),

              //----------------------------------
              // TITLE
              //----------------------------------

              Text(
                "No matter where life takes us,\n"
                "you'll always be my\n"
                "favourite person. ❤️",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                  color: const Color(0xffE58AA8),
                ),
              ),

              const SizedBox(height: 28),
                            //----------------------------------
              // MESSAGE CARD
              //----------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffFFF9FA),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xffFFE4C7),
                    width: 1,
                  ),
                ),

                child: Column(
                  children: [

                    Text(
                      "Thank you for being my safe place.\n"
                      "Thank you for choosing me every single day.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff7B5A5A),
                        height: 1.9,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "I don't know what tomorrow looks like,\n"
                      "but I know I want every tomorrow with you.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff7B5A5A),
                        height: 1.9,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "No distance,\n"
                      "no silence,\n"
                      "no fight...\n"
                      "can ever change what you mean to me, Nishant",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff7B5A5A),
                        height: 2,
                      ),
                    ),

                    const SizedBox(height: 30),
                                        //----------------------------------
                    // FINAL MESSAGE
                    //----------------------------------

                    Text(
                      "You're my favourite chapter,\n"
                      "my happiest memory,\n"
                      "and my safest home.\n"
                      "No matter what happens,\n"
                      "I'll always choose you!!\n"
                      "again...\n"
                      "and again...\n"
                      "and forever. ❤️",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xffE58AA8),
                        height: 2,
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Divider(
                      thickness: 1,
                      color: Color(0xffFFE4C7),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      "- Yours Madam Zi 💛",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffE58AA8),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Made with endless love,\njust for you.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              //----------------------------------
              // BOTTOM BUTTON
              //----------------------------------

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                 onPressed: () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const LoveHubScreen(),
    ),
    (route) => false,
  );
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffE58AA8),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Back to Love ❤️",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }
  }