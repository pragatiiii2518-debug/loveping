import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedEnvelope extends StatefulWidget {
  final VoidCallback onOpened;
  final bool closeEnvelope;

  const AnimatedEnvelope({
    super.key,
    required this.onOpened,
    this.closeEnvelope = false,
  });

  @override
  State<AnimatedEnvelope> createState() => _AnimatedEnvelopeState();
}

class _AnimatedEnvelopeState extends State<AnimatedEnvelope>
    with SingleTickerProviderStateMixin {
  late AnimationController _flapController;
  late Animation<double> _flapRotation;

  bool opened = false;

  @override
  void initState() {
    super.initState();

    _flapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _flapRotation = Tween<double>(
      begin: 0,
      end: -math.pi * 0.65,
    ).animate(
      CurvedAnimation(
        parent: _flapController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _openEnvelope() async {
    if (opened) return;

    opened = true;

    await _flapController.forward();

    widget.onOpened();
  }

  Future<void> _closeEnvelope() async {
    await _flapController.reverse();

    opened = false;
  }

  @override
  void didUpdateWidget(covariant AnimatedEnvelope oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.closeEnvelope) {
      _closeEnvelope();
    }
  }

  @override
  void dispose() {
    _flapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    // Bigger envelope
    final width = screen.width * 0.95;

    return GestureDetector(
      onTap: _openEnvelope,
      child: SizedBox(
        width: width,
        height: width * 0.62,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [

            //--------------------------------------------------
            // Envelope Body
            //--------------------------------------------------

            Positioned(
              bottom: 0,
              child: Image.asset(
                "assets/images/envelope_body.png",
                width: width,
                fit: BoxFit.contain,
              ),
            ),

            //--------------------------------------------------
            // Flap
            //--------------------------------------------------

            Positioned(
              top: -113,
              child: AnimatedBuilder(
                animation: _flapController,
                builder: (_, child) {
                  return Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(_flapRotation.value),
                    child: child,
                  );
                },
                child: Image.asset(
                  "assets/images/envelope_flap.png",
                  width: width,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}