import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'signup_screen.dart';
import 'love_welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {

  //--------------------------------------------------------
  // FIREBASE
  //--------------------------------------------------------

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  //--------------------------------------------------------
  // CONTROLLERS
  //--------------------------------------------------------

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isLoading = false;

  //--------------------------------------------------------
  // ANIMATIONS
  //--------------------------------------------------------

  late AnimationController _controller;
  late AnimationController _heartController;

  late Animation<double> _fade;
  late Animation<Offset> _slide;

  //--------------------------------------------------------
  // INIT
  //--------------------------------------------------------

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

  //--------------------------------------------------------
  // DISPOSE
  //--------------------------------------------------------

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    _controller.dispose();
    _heartController.dispose();

    super.dispose();
  }
    //--------------------------------------------------------
  // LOGIN FUNCTION
  //--------------------------------------------------------

  Future<void> login() async {

    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter email and password.",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoveWelcomeScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      String message = "Login failed.";

      switch (e.code) {

        case "invalid-email":
          message = "Invalid email address.";
          break;

        case "invalid-credential":
          message = "Incorrect email or password.";
          break;

        case "user-not-found":
          message = "No account found with this email.";
          break;

        case "wrong-password":
          message = "Incorrect password.";
          break;

        default:
          message = e.message ?? "Login failed.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
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

  //--------------------------------------------------------
  // FLOATING HEART
  //--------------------------------------------------------

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

  //--------------------------------------------------------
  // TEXTFIELD DECORATION
  //--------------------------------------------------------

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

        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide.none,
      ),
    );
  }
    //--------------------------------------------------------
  // BUILD
  //--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          //--------------------------------------------------------
          // BACKGROUND IMAGE
          //--------------------------------------------------------

          Positioned.fill(
            child: Image.asset(
              "assets/images/login_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          //--------------------------------------------------------
          // DARK OVERLAY
          //--------------------------------------------------------

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

          //--------------------------------------------------------
          // FLOATING HEARTS
          //--------------------------------------------------------

          heart(30,170,26,.6,.0),
          heart(320,120,20,.5,.3),
          heart(55,330,24,.5,.5),
          heart(310,470,18,.4,.7),
          heart(70,660,26,.5,.2),
          heart(330,820,22,.6,.8),

          //--------------------------------------------------------
          // LOGIN CARD
          //--------------------------------------------------------

          Align(
            alignment: const Alignment(0,.15),
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
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(.45),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(
                            "let's go ❤️",
                            style: GoogleFonts.pacifico(
                              fontSize: 34,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 35),

                          TextField(
                            controller: emailController,
                            keyboardType:
                                TextInputType.emailAddress,
                            decoration: textDecoration(
                              "Email",
                              Icons.email,
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: textDecoration(
                              "Password",
                              Icons.lock,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),
                          Container(
  width: double.infinity,
  height: 56,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFFFFC76B).withOpacity(.55),
        blurRadius: 22,
        spreadRadius: 2,
      ),
    ],
  ),

  child: ElevatedButton(

    onPressed: isLoading
        ? null
        : () async {
            print("LOGIN BUTTON PRESSED");

            await login();

            print("LOGIN FUNCTION FINISHED");
          },

    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFC76B),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),

    child: isLoading
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
        : Text(
            "LOGIN",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
  ),
),

const SizedBox(height: 22),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      "Don't have an account?",
      style: GoogleFonts.poppins(
        color: Colors.white,
      ),
    ),

    TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SignUpScreen(),
          ),
        );
      },
      child: Text(
        "Sign Up",
        style: GoogleFonts.poppins(
          color: const Color(0xFFFFD77A),
          fontWeight: FontWeight.bold,
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