import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  Widget heart(
      double left,
      double top,
      double size,
      double opacity,
      double animation,
      ) {
    return Positioned(
      left: left,
      top: top - animation * 12,
      child: Opacity(
        opacity: opacity - animation * 0.2,
        child: Icon(
          Icons.favorite,
          color: Colors.pinkAccent,
          size: size,
        ),
      ),
    );
  }

  Widget customButton(String title, VoidCallback onTap) {
    return Container(
      width: 280,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(.25),
            blurRadius: 20,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(.95),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xffD85A8A),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _heartController,
        builder: (context, child) {
          double t = _heartController.value;

          return Stack(
            children: [

              /// Background
              Positioned.fill(
                child: Image.asset(
                  "assets/images/welcome_bg.png",
                  fit: BoxFit.cover,
                ),
              ),

              /// Floating Hearts
              heart(40, 120, 28, .6, t),
              heart(320, 170, 22, .5, 1 - t),
              heart(55, 350, 26, .5, t),
              heart(335, 520, 24, .4, 1 - t),
              heart(90, 740, 28, .6, t),
              heart(315, 920, 24, .5, 1 - t),

              /// Buttons
              Align(
                alignment: const Alignment(0, 0.84),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    customButton(
                      "Login",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    customButton(
                      "Sign Up",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}