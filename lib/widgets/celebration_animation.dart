import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class CelebrationAnimation extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final CelebrationType type;

  const CelebrationAnimation({
    Key? key,
    required this.child,
    required this.trigger,
    this.type = CelebrationType.confetti,
  }) : super(key: key);

  @override
  State<CelebrationAnimation> createState() => _CelebrationAnimationState();
}

enum CelebrationType {
  confetti,
  fireworks,
  sparkles,
  checkmark,
}

class _CelebrationAnimationState extends State<CelebrationAnimation>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_animationController);

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(CelebrationAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _celebrate();
    }
  }

  void _celebrate() {
    switch (widget.type) {
      case CelebrationType.confetti:
        _confettiController.play();
        break;
      case CelebrationType.fireworks:
      case CelebrationType.sparkles:
      case CelebrationType.checkmark:
        _animationController.forward(from: 0);
        break;
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main content
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: widget.child,
            );
          },
        ),

        // Confetti overlay
        if (widget.type == CelebrationType.confetti)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.2,
              shouldLoop: false,
              colors: const [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
                Color(0xFFEC4899),
                Color(0xFF10B981),
                Color(0xFFF59E0B),
              ],
            ),
          ),

        // Checkmark animation
        if (widget.type == CelebrationType.checkmark)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _animationController.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value * 2,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              );
            },
          ),

        // Sparkles animation
        if (widget.type == CelebrationType.sparkles)
          ...List.generate(8, (index) {
            final angle = (index * pi / 4);
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final distance = 80 * _animationController.value;
                return Positioned(
                  left: MediaQuery.of(context).size.width / 2 +
                      cos(angle) * distance -
                      10,
                  top: MediaQuery.of(context).size.height / 2 +
                      sin(angle) * distance -
                      10,
                  child: Opacity(
                    opacity: 1 - _animationController.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Icon(
                        Icons.star_rounded,
                        color: [
                          const Color(0xFFF59E0B),
                          const Color(0xFFEC4899),
                          const Color(0xFF6366F1),
                        ][index % 3],
                        size: 20,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      ],
    );
  }
}

// Confetti overlay widget for full-screen celebrations
class FullScreenConfetti extends StatefulWidget {
  const FullScreenConfetti({Key? key}) : super(key: key);

  @override
  State<FullScreenConfetti> createState() => _FullScreenConfettiState();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (context) => const FullScreenConfetti(),
    );
  }
}

class _FullScreenConfettiState extends State<FullScreenConfetti> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 5));
    _controller.play();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Left confetti
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirection: pi / 4,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.3,
            colors: const [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
              Color(0xFF10B981),
              Color(0xFFF59E0B),
            ],
          ),
        ),
        // Right confetti
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirection: 3 * pi / 4,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.3,
            colors: const [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
              Color(0xFF10B981),
              Color(0xFFF59E0B),
            ],
          ),
        ),
        // Center message
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.celebration_rounded,
                  color: Colors.white,
                  size: 60,
                ),
                SizedBox(height: 16),
                Text(
                  '🎉 Awesome!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Keep up the great work!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
