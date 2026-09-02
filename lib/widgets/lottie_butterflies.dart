import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieButterflies extends StatefulWidget {
  final bool visible;

  const LottieButterflies({
    super.key,
    required this.visible,
  });

  @override
  State<LottieButterflies> createState() =>
      _LottieButterfliesState();
}

class _LottieButterfliesState
    extends State<LottieButterflies>
    with TickerProviderStateMixin {

  final List<AnimationController> controllers = [];

  final List<Offset> positions = [
    Offset(0.05, 0.65),
    Offset(0.25, 0.55),
    Offset(0.50, 0.70),
    Offset(0.75, 0.58),
    Offset(0.90, 0.68),
    Offset(0.15, 0.35),
    Offset(0.55, 0.25),
    Offset(0.85, 0.32),
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < positions.length; i++) {
      controllers.add(AnimationController(vsync: this));
    }
  }

  @override
  void didUpdateWidget(covariant LottieButterflies oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.visible && !oldWidget.visible) {
      for (final c in controllers) {
        c.reset();
      }
    }
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) {
      return const SizedBox.shrink();
    }

    final screen = MediaQuery.of(context).size;

    return IgnorePointer(
      child: Stack(
        children: List.generate(
          positions.length,
          (index) {
            return Positioned(
              left: screen.width * positions[index].dx,
              top: screen.height * positions[index].dy,
              child: Opacity(
                opacity: 0.55,
                child: SizedBox(
                  width: 415,
                  height: 415,
                  child: Lottie.asset(
                    "assets/animations/butterflies.json",
                    controller: controllers[index],
                    repeat: false,
                    fit: BoxFit.contain,
                    onLoaded: (composition) async {

                      controllers[index].duration =
                          composition.duration * 1;

                      await Future.delayed(
                        Duration(milliseconds: index * 220),
                      );

                      if (mounted && widget.visible) {
                        controllers[index].forward(from: 0);
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}