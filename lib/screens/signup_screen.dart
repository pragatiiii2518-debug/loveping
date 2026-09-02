import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';


import 'login_screen.dart';
import 'love_welcome_screen.dart';

import '../services/firestore_service.dart';

    final FirestoreService firestoreService =
    FirestoreService();


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {

  //------------------------------------------------------
  // FIREBASE
  //------------------------------------------------------

  final FirebaseAuth _auth = FirebaseAuth.instance;

  

  //------------------------------------------------------
  // TEXT CONTROLLERS
  //------------------------------------------------------

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  //------------------------------------------------------
  // ANIMATION
  //------------------------------------------------------

  late AnimationController _controller;
  late AnimationController _heartController;

  late Animation<double> _fade;
  late Animation<Offset> _slide;
    //------------------------------------------------------
  // INIT
  //------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 700,
      ),
    );

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 6,
      ),
    )..repeat();

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _slide = Tween<Offset>(
      begin: const Offset(0, .25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  //------------------------------------------------------
  // DISPOSE
  //------------------------------------------------------

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    _controller.dispose();
    _heartController.dispose();

    super.dispose();
  }

  //------------------------------------------------------
  // SIGN UP
  //------------------------------------------------------

  Future<void> signUp() async {

    FocusScope.of(context).unfocus();

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm =
        confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    if (password != confirm) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Passwords do not match",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final loveId =
    "LP${DateTime.now().millisecondsSinceEpoch}";

    await firestoreService.createUser(
  uid: credential.user!.uid,
  name: name,
  email: email,
  loveId: loveId,
);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const LoveWelcomeScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? "Signup failed",
          ),
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
    //------------------------------------------------------
  // FLOATING HEARTS
  //------------------------------------------------------

  Widget heart(
    double left,
    double top,
    double size,
    double opacity,
    double delay,
  ) {
    return AnimatedBuilder(
      animation: _heartController,
      builder: (context, child) {
        double t =
            (_heartController.value + delay) % 1;

        return Positioned(
          left: left,
          top: top - t * 40,
          child: Opacity(
            opacity: opacity * (1 - t),
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

  //------------------------------------------------------
  // TEXTFIELD DECORATION
  //------------------------------------------------------

  InputDecoration textDecoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.black54,
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.pink,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(.82),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  //------------------------------------------------------
  // BUILD
  //------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              "assets/images/login_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.35),
                    Colors.black.withOpacity(.60),
                  ],
                ),
              ),
            ),
          ),

          heart(30,170,26,.6,0),
          heart(320,120,20,.5,.3),
          heart(55,330,24,.5,.5),
          heart(310,470,18,.4,.7),
          heart(70,660,26,.5,.2),
          heart(330,820,22,.6,.8),

          Align(
            alignment: const Alignment(0,.10),
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 25,
                      sigmaY: 25,
                    ),
                    child: Container(
                      width: 355,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.18),
                        borderRadius:
                            BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(.45),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(
                            "Hello stranger!! ❤️",
                            style: GoogleFonts.pacifico(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 30),
                                                    TextField(
                            controller: nameController,
                            decoration: textDecoration(
                              "Name",
                              Icons.person,
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller: emailController,
                            keyboardType:
                                TextInputType.emailAddress,
                            decoration: textDecoration(
                              "Email",
                              Icons.email,
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: textDecoration(
                              "Password",
                              Icons.lock,
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller:
                                confirmPasswordController,
                            obscureText: true,
                            decoration: textDecoration(
                              "Confirm Password",
                              Icons.lock_outline,
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      print(
                                          "SIGNUP BUTTON PRESSED");

                                      await signUp();

                                      print(
                                          "SIGNUP FUNCTION FINISHED");
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(
                                        0xFFFFC76B),
                                foregroundColor:
                                    Colors.white,
                                elevation: 0,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(30),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child:
                                          CircularProgressIndicator(
                                        color:
                                            Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      "SIGN UP",
                                      style:
                                          GoogleFonts
                                              .poppins(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Text(
                                "Already have an account?",
                                style:
                                    GoogleFonts
                                        .poppins(
                                  color: Colors.white,
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Login",
                                  style:
                                      GoogleFonts
                                          .poppins(
                                    color:
                                        const Color(
                                            0xFFFFD77A),
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ],
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