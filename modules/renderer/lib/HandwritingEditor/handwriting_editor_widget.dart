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
    return Listener(
      onPointerMove: (event) {
        final position = event.localPosition;
        final Touch touch = (
          position: (x: position.dx, y: position.dy),
          pressure: event.pressure.clamp(
            0.25,
            1.0,
          ), // Use the actual pressure from the event
        );
        setState(() {
          touches.add(touch);
        });
      },
      child: HandwritingWidget(handwriting: Handwriting(touches: touches)),
    );
  }
}
