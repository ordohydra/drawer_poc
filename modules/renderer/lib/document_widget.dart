import 'package:flutter/cupertino.dart';
import 'package:model/document.dart';
import 'package:renderer/handwriting_widget.dart';

final class DocumentWidget extends StatelessWidget {
  final Document document;

  const DocumentWidget({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(document.title, textAlign: TextAlign.left),
        ),
        //HandwritingWidget(handwriting: document.handwriting),
      ],
    );
  }
}
