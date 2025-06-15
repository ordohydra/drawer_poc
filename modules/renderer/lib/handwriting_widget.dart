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

    for (final touch in touches) {
      canvas.drawCircle(
        Offset(touch.position.x, touch.position.y),
        touch.pressure * 10,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
