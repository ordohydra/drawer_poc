import 'package:flutter/material.dart';
import 'package:renderer/document_widget.dart';
import 'package:model/document.dart';
import 'package:model/handwriting.dart';
import 'package:renderer/HandwritingEditor/handwriting_editor_widget.dart';

const Document document = Document(
  id: '1',
  title: 'Sample Document',
  handwriting: Handwriting(
    touches: [
      (position: (x: 10.0, y: 20.0), pressure: 0.5),
      (position: (x: 30.0, y: 40.0), pressure: 0.7),
    ],
  ),
);

final class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DocumentWidget(document: document),
          HandwritingEditorWidget(),
        ],
      ),
    );
  }
}
