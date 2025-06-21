import 'package:flutter/cupertino.dart';
import 'package:model/handwriting.dart';
import 'package:model/touch.dart';

final class HandwritingWidget extends StatelessWidget {
  final Handwriting handwriting;

  const HandwritingWidget({super.key, required this.handwriting});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HandwritingPainter(handwriting.touches),
      child: const SizedBox(width: double.infinity, height: double.infinity),
    );
  }
}

final class _HandwritingPainter extends CustomPainter {
  final List<Touch> touches;

  const _HandwritingPainter(this.touches);

  @override
  void paint(Canvas canvas, Size size) {
    if (touches.length < 2) return;

    final path = Path();

    // Compute the first midpoint
    Offset p0 = Offset(touches[0].position.x, touches[0].position.y);
    for (int i = 1; i < touches.length; i++) {
      Offset p1 = Offset(touches[i].position.x, touches[i].position.y);
      Offset mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);

      // Calculate average pressure for this segment
      double avgPressure = (touches[i - 1].pressure + touches[i].pressure) / 2;

      // Calculate velocity (distance / time) for this segment
      double dt = (touches[i].timestamp - touches[i - 1].timestamp)
          .abs()
          .toDouble();
      double distance = (p1 - p0).distance;
      double velocity = dt > 0 ? distance / dt : 1.0;

      // Adjust stroke width: higher pressure = thicker, higher velocity = thinner
      // You can tweak these multipliers for your needs
      double strokeWidth = (avgPressure * 16.0) / (velocity * 160.0 + 1.0);
      strokeWidth = strokeWidth.clamp(1.0, 24.0);

      final paint = Paint()
        ..color = const Color(0xFF000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      if (i == 1) {
        path.moveTo(p0.dx, p0.dy);
      }

      path.quadraticBezierTo(
        p0.dx,
        p0.dy, // control point
        mid.dx,
        mid.dy, // end point
      );

      canvas.drawPath(path, paint);

      // Start a new path for the next segment to allow variable stroke width
      path.reset();
      path.moveTo(mid.dx, mid.dy);

      p0 = p1;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
