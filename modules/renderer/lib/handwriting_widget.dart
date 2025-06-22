import 'dart:ui' as ui;
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
    if (touches.length < 3) return;

    final shader = LinearGradient(
      colors: [const Color(0xFF000000), const Color(0xFF4444FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    for (int i = 2; i < touches.length; i++) {
      Offset p0 = Offset(touches[i - 2].position.x, touches[i - 2].position.y);
      Offset p1 = Offset(touches[i - 1].position.x, touches[i - 1].position.y);
      Offset p2 = Offset(touches[i].position.x, touches[i].position.y);
      Offset mid1 = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      Offset mid2 = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);

      //double avgPressure = (touches[i - 1].pressure + touches[i].pressure) / 2;
      double dt = (touches[i].timestamp - touches[i - 2].timestamp)
          .abs()
          .toDouble();
      double distance = (p2 - p0).distance;
      double velocity = dt > 0 ? distance / dt : 1.0;
      // double strokeWidth = (avgPressure * 16.0) / (velocity * 160.0 + 1.0);
      // strokeWidth = strokeWidth.clamp(1.0, 24.0);

      // Sample points along the quadratic Bézier
      const int steps = 16;
      List<Offset> leftEdge = [];
      List<Offset> rightEdge = [];

      for (int s = 0; s <= steps; s++) {
        double t = s / steps;
        // Quadratic Bézier formula
        double x =
            (1 - t) * (1 - t) * mid1.dx +
            2 * (1 - t) * t * mid1.dx +
            t * t * mid2.dx;
        double y =
            (1 - t) * (1 - t) * mid1.dy +
            2 * (1 - t) * t * mid1.dy +
            t * t * mid2.dy;

        // Interpolate width along the segment
        double width = lerpDouble(
          (touches[i - 1].pressure * 32.0) / (velocity * 0.1 + 1.0),
          (touches[i].pressure * 32.0) / (velocity * 0.1 + 1.0),
          t,
        )!.clamp(2.0, 24.0);

        // Compute direction (tangent)
        double dx =
            2 * (1 - t) * (mid2.dx - mid1.dx) + 2 * t * (mid2.dx - mid1.dx);
        double dy =
            2 * (1 - t) * (mid2.dy - mid1.dy) + 2 * t * (mid2.dy - mid1.dy);
        Offset tangent = Offset(dx, dy);
        if (tangent.distance == 0) tangent = const Offset(1, 0);
        Offset normal = Offset(-tangent.dy, tangent.dx).normalize();

        leftEdge.add(Offset(x, y) + normal * (width / 2));
        rightEdge.add(Offset(x, y) - normal * (width / 2));
      }

      // Combine left and right edges to form the ribbon
      List<ui.Offset> vertices = [...leftEdge, ...rightEdge.reversed];

      // Build triangle indices for the ribbon (triangle strip)
      List<int> indices = [];
      int n = leftEdge.length;
      for (int j = 0; j < n - 1; j++) {
        // Two triangles per quad
        indices.add(j);
        indices.add(j + 1);
        indices.add(2 * n - j - 2);

        indices.add(j + 1);
        indices.add(2 * n - j - 2);
        indices.add(2 * n - j - 3);
      }

      final paint = Paint()
        ..shader = shader
        ..style = PaintingStyle.fill;

      final ui.Vertices ribbonVertices = ui.Vertices(
        ui.VertexMode.triangles,
        vertices,
        indices: indices,
      );

      canvas.drawVertices(ribbonVertices, BlendMode.srcOver, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

double? lerpDouble(num a, num b, double t) {
  return a + (b - a) * t;
}

// Extension to normalize Offset
extension OffsetExtension on Offset {
  Offset normalize() {
    double length = this.distance;
    if (length == 0) return const Offset(0, 0);
    return Offset(this.dx / length, this.dy / length);
  }
}
