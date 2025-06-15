import 'package:flutter/widgets.dart';
import 'package:model/handwriting.dart';
import 'package:model/touch.dart';
import 'package:renderer/handwriting_widget.dart';

final class HandwritingEditorWidget extends StatefulWidget {
  const HandwritingEditorWidget({super.key});

  @override
  State<HandwritingEditorWidget> createState() =>
      _HandwritingEditorWidgetState();
}

class _HandwritingEditorWidgetState extends State<HandwritingEditorWidget> {
  List<Touch> touches = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final position = details.localPosition;
        final Touch touch = (
          position: (x: position.dx, y: position.dy),
          pressure: 1.0, // Default pressure
        );
        setState(() {
          touches.add(touch);
        });
      },
      onPanUpdate: (details) {
        final position = details.localPosition;
        final Touch touch = (
          position: (x: position.dx, y: position.dy),
          pressure: 1.0, // Default pressure
        );
        setState(() {
          touches.add(touch);
        });
      },
      child: HandwritingWidget(handwriting: Handwriting(touches: touches)),
    );
  }
}

/*
class _HandwritingPainter extends CustomPainter {
  final List<Touch> touches;

  _HandwritingPainter(this.touches);

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
*/
