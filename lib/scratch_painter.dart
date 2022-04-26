import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ScractcherPainter extends CustomPainter {
  final ui.Image image;
  final List<List<Offset>> pointsList;

  ScractcherPainter(this.image, this.pointsList);

  @override
  void paint(Canvas canvas, Size size) {
    final outputRect =
        Rect.fromLTWH(size.width / 2 - 100, size.height / 2 - 100, 200, 200);
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final sizes = applyBoxFit(BoxFit.cover, imageSize, outputRect.size);
    final Rect inputSubrect =
        Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect =
        Alignment.center.inscribe(sizes.destination, outputRect);

    canvas.drawImageRect(image, inputSubrect, outputSubrect, Paint());
    canvas.saveLayer(null, Paint());

    final areaRect = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawRect(areaRect, Paint()..color = Colors.blueAccent);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..blendMode = BlendMode.src
      ..color = Colors.transparent;

    final pathBackground = Path();
    pathBackground.addRect(outputRect);

    final path = Path();

    for (var i = 0; i < pointsList.length; i++) {
      final points = pointsList[i].toSet().toList();
      for (var j = 0; j < points.length; j++) {
        if (j == 0) {
          path.moveTo(points[j].dx, points[j].dy);
        } else {
          path.lineTo(points[j].dx, points[j].dy);
        }
      }
    }

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ScractcherPainter oldDelegate) {
    return true;
  }
}
