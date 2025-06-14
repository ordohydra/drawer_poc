import 'package:flutter/cupertino.dart';
import 'package:model/handwriting.dart';

final class HandwritingWidget extends StatelessWidget {
  final Handwriting handwriting;

  const HandwritingWidget({super.key, required this.handwriting});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Handwriting touches: ${handwriting.touches.length}',
        textAlign: TextAlign.center,
      ),
    );
  }
}
