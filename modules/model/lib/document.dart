import 'package:model/handwriting.dart';

final class Document {
  final String id;
  final String title;
  final Handwriting handwriting;

  const Document({
    required this.id,
    required this.title,
    required this.handwriting,
  });

  @override
  String toString() {
    return 'Document(id: $id, title: $title)';
  }
}
