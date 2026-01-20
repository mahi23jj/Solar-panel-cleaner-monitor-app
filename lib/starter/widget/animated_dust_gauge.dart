import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedDustGauge extends StatelessWidget {
  final double value;
  final double max;

  const AnimatedDustGauge({
    super.key,
    required this.value,
    required this.max,
  });

  Color _getColor(double v) {
    if (v >= max) return Colors.red;
    if (v >= max * 0.7) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        final progress = (animatedValue / max).clamp(0.0, 1.0);

        return SizedBox(
          width: 180,
          height: 100,
          child: CustomPaint(
            painter: _GaugePainter(
              progress: progress,
              color: _getColor(animatedValue),
            ),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color color;

  _GaugePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final valuePaint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      bgPaint,
    );

    // Value arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * progress,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
