import 'package:flutter/material.dart';

class AnimatedLearningIcon extends StatefulWidget {
  final double size;
  final Color color;

  const AnimatedLearningIcon({
    Key? key,
    this.size = 100,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  _AnimatedLearningIconState createState() => _AnimatedLearningIconState();
}

class _AnimatedLearningIconState extends State<AnimatedLearningIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Main rotation and scale animation
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Bounce animation
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    // Start animations
    _controller.repeat(reverse: true);
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _bounceController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withOpacity(0.8),
                      widget.color,
                      widget.color.withOpacity(0.6),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school,
                  size: widget.size * 0.6,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FloatingBookIcon extends StatefulWidget {
  final double size;
  final Offset position;
  final Color color;

  const FloatingBookIcon({
    Key? key,
    this.size = 30,
    this.position = Offset.zero,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  _FloatingBookIconState createState() => _FloatingBookIconState();
}

class _FloatingBookIconState extends State<FloatingBookIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
        milliseconds: 2000 + (widget.position.dx * 100).toInt(),
      ),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: 0,
      end: 20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Positioned(
          left: widget.position.dx,
          top: widget.position.dy + _floatAnimation.value,
          child: Opacity(
            opacity: 0.7,
            child: Icon(
              Icons.menu_book,
              size: widget.size,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}
