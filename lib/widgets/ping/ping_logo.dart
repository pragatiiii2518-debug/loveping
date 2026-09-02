import 'package:flutter/material.dart';

class PingLogo extends StatefulWidget {
  final VoidCallback onTap;

  const PingLogo({
    super.key,
    required this.onTap,
  });

  @override
  State<PingLogo> createState() => _PingLogoState();
}

class _PingLogoState extends State<PingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scale;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.96,
      end: 1.06,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _glow = Tween<double>(
      begin: 30,
      end: 70,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: Stack(
              alignment: Alignment.center,
              children: [

                //--------------------------------------------------
                // OUTER PINK HALO
                //--------------------------------------------------

                Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(.30),
                        blurRadius: _glow.value,
                        spreadRadius: 20,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(.30),
                        blurRadius: 35,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),

                //--------------------------------------------------
                // LOGO
                //--------------------------------------------------

                Hero(
                  tag: "loveping_logo",
                  child: Image.asset(
                    "assets/images/ping_logo.png",
                    width: 230,
                  ),
                ),

                //--------------------------------------------------
                // SPARKLES
                //--------------------------------------------------

                const Positioned(
                  top: 20,
                  right: 60,
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 18,
                  ),
                ),

                const Positioned(
                  bottom: 35,
                  left: 45,
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.pinkAccent,
                    size: 16,
                  ),
                ),

                const Positioned(
                  left: 20,
                  top: 120,
                  child: Icon(
                    Icons.star,
                    color: Colors.white70,
                    size: 10,
                  ),
                ),

                const Positioned(
                  right: 25,
                  bottom: 120,
                  child: Icon(
                    Icons.star,
                    color: Colors.white70,
                    size: 10,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}