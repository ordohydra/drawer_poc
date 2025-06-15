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
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    // for (final touch in touches) {
    //   canvas.drawCircle(
    //     Offset(touch.position.x, touch.position.y),
    //     touch.pressure * 10,
    //     paint,
    //   );
    // }

    // Draw rounded lines between touches
    for (int i = 0; i < touches.length - 1; i++) {
      final touch1 = touches[i];
      final touch2 = touches[i + 1];

      final startOffset = Offset(touch1.position.x, touch1.position.y);
      final endOffset = Offset(touch2.position.x, touch2.position.y);

      final midPoint = Offset(
        (startOffset.dx + endOffset.dx) / 2,
        (startOffset.dy + endOffset.dy) / 2,
      );

      // Draw a line with rounded ends
      canvas.drawLine(startOffset, midPoint, paint);
      canvas.drawLine(midPoint, endOffset, paint);
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
