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
      child: Container(width: double.infinity, height: double.infinity),
    );
  }
}

final class _HandwritingPainter extends CustomPainter {
  final List<Touch> touches;

  const _HandwritingPainter(this.touches);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (touches.length >= 2) {
      final path = Path();

      // Compute the first midpoint
      Offset p0 = Offset(touches[0].position.x, touches[0].position.y);
      for (int i = 1; i < touches.length; i++) {
        Offset p1 = Offset(touches[i].position.x, touches[i].position.y);
        Offset mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);

        if (i == 1) {
          path.moveTo(p0.dx, p0.dy);
        }

        path.quadraticBezierTo(
          p0.dx,
          p0.dy, // control point
          mid.dx,
          mid.dy, // end point
        );

        p0 = p1;
      }

      // Draw the last segment to the last point
      path.lineTo(
        Offset(touches.last.position.x, touches.last.position.y).dx,
        Offset(touches.last.position.x, touches.last.position.y).dy,
      );

      canvas.drawPath(path, paint);
    }

    // Draw circles at the start and end of the path
    if (touches.isNotEmpty) {
      final firstTouch = touches.first;
      final lastTouch = touches.last;

      canvas.drawCircle(
        Offset(firstTouch.position.x, firstTouch.position.y),
        firstTouch.pressure * 10,
        paint,
      );

      canvas.drawCircle(
        Offset(lastTouch.position.x, lastTouch.position.y),
        lastTouch.pressure * 10,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
