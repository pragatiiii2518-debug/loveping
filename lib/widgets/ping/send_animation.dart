import 'package:flutter/material.dart';

class SendAnimation extends StatefulWidget {
  final Widget child;
  final bool animate;

  const SendAnimation({
    super.key,
    required this.child,
    required this.animate,
  });

  @override
  State<SendAnimation> createState() => _SendAnimationState();
}

class _SendAnimationState extends State<SendAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _scale;

  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(

      vsync: this,

      duration: const Duration(milliseconds: 700),

    );

    _scale = Tween<double>(

      begin: 1,

      end: 1.35,

    ).animate(

      CurvedAnimation(

        parent: _controller,

        curve: Curves.easeOutBack,

      ),

    );

    _opacity = Tween<double>(

      begin: 1,

      end: 0,

    ).animate(

      CurvedAnimation(

        parent: _controller,

        curve: Curves.easeOut,

      ),

    );
  }

  @override
  void didUpdateWidget(covariant SendAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(

      animation: _controller,

      builder: (context, child) {

        return Opacity(

          opacity: _opacity.value,

          child: Transform.scale(

            scale: _scale.value,

            child: widget.child,

          ),

        );

      },

    );

  }

}