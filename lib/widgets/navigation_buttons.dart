import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final bool showNext;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const NavigationButtons({
    super.key,
    required this.showNext,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        //--------------------------------------------------
        // BACK BUTTON
        //--------------------------------------------------

        Positioned(
          top: 55,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.18),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: Colors.white24,
              ),
            ),
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
          ),
        ),

        //--------------------------------------------------
        // NEXT BUTTON
        //--------------------------------------------------

        Positioned(
          bottom: 35,
          right: 20,
          child: AnimatedScale(
            scale: showNext ? 1 : 0.90,
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,

            child: AnimatedOpacity(
              opacity: showNext ? 1 : 0,
              duration: const Duration(milliseconds: 700),

              child: IgnorePointer(
                ignoring: !showNext,

                child: GestureDetector(
                  onTap: onNext,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 15,
                    ),

                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(40),

                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffFF5FA2),
                          Color(0xffFF7CC3),
                        ],
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent
                              .withOpacity(.45),
                          blurRadius: 22,
                          spreadRadius: 3,
                        ),
                      ],
                    ),

                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(width: 10),

                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
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
    );
  }
}