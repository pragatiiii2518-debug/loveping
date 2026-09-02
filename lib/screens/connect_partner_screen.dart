import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/firestore_service.dart';

class ConnectPartnerScreen extends StatefulWidget {
  const ConnectPartnerScreen({super.key});

  @override
  State<ConnectPartnerScreen> createState() =>
      _ConnectPartnerScreenState();
}

class _ConnectPartnerScreenState
    extends State<ConnectPartnerScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController loveIdController =
      TextEditingController();

  final FirestoreService firestoreService =
      FirestoreService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  late AnimationController _heartController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    loveIdController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  Future<void> connectPartner() async {
    FocusScope.of(context).unfocus();

    final partnerLoveId =
        loveIdController.text.trim();

    if (partnerLoveId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your partner's Love ID"),
        ),
      );
      return;
    }

    final currentUser = auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login first"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final connected =
          await firestoreService.connectPartner(
        myUid: currentUser.uid,
        partnerLoveId: partnerLoveId,
      );

      if (!mounted) return;

      if (connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "❤️ You are connected with your partner!",
            ),
            backgroundColor: Colors.green,
          ),
        );

        loveIdController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Love ID not found. Please check the ID.",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Something went wrong: $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget floatingHeart(
    double left,
    double top,
    double size,
    double delay,
  ) {
    return AnimatedBuilder(
      animation: _heartController,
      builder: (context, child) {
        final value =
            (_heartController.value + delay) % 1;

        return Positioned(
          left: left,
          top: top - value * 35,
          child: Opacity(
            opacity: 0.7 * (1 - value),
            child: Icon(
              Icons.favorite,
              color: Colors.pink.shade200,
              size: size,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE5F0),
              Color(0xFFE9D5FF),
              Color(0xFFFFDDEB),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              floatingHeart(35, 120, 25, 0),
              floatingHeart(320, 180, 20, .3),
              floatingHeart(70, 500, 22, .5),
              floatingHeart(300, 620, 26, .7),
              floatingHeart(160, 730, 18, .2),

              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.72),
                      borderRadius:
                          BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink
                              .withOpacity(.12),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.pink,
                          size: 65,
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Connect Your Love ❤️",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.pacifico(
                            fontSize: 30,
                            color: const Color(
                              0xFFB83280,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "Enter your partner's Love ID",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 30),

                        TextField(
                          controller: loveIdController,
                          textCapitalization:
                              TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: "Example: LP1787422193179",
                            prefixIcon: const Icon(
                              Icons.favorite_border,
                              color: Colors.pink,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(18),
                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : connectPartner,
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFFF7EB3),
                              foregroundColor:
                                  Colors.white,
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  30,
                                ),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 23,
                                    width: 23,
                                    child:
                                        CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    "CONNECT ❤️",
                                    style:
                                        GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Your Love ID is private.\n"
                          "Only share it with your partner.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
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
}