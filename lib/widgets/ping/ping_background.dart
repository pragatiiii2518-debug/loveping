import 'package:flutter/material.dart';

class PingBackground extends StatelessWidget {
  const PingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffFFF7FA),
            Color(0xffFFE9F3),
            Color(0xffFFD5E8),
            Color(0xffFFC7DF),
          ],
        ),
      ),
    );
  }
}