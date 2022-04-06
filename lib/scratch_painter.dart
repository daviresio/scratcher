import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class ScractcherPainter extends CustomPainter {
  final ui.Image image;
  final List<Offset> points;

  ScractcherPainter(this.image, this.points);

  @override
  void paint(Canvas canvas, Size size) {
    // criar um retangulo de 200x200 e redimensiona a imagem para caber nele.
    // Pq a resolucao da imagem é maior que o tamanho da tela.
    final outputRect =
        Rect.fromLTWH(size.width / 2 - 100, size.height / 2 - 100, 200, 200);
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final sizes = applyBoxFit(BoxFit.cover, imageSize, outputRect.size);
    final Rect inputSubrect =
        Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect =
        Alignment.center.inscribe(sizes.destination, outputRect);

    // Desenha a imagem
    canvas.drawImageRect(image, inputSubrect, outputSubrect, Paint());

    // cor do background
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 10.0
      ..color = Colors.redAccent;

    // esse é o retangulo por cima da imagem
    final pathBackground = Path();
    pathBackground.addRect(outputRect);

    // pega os pontos capturados pelo gestureDetector e desenha um circulo neles
    final pathScratch = Path();
    for (var i = 0; i < points.length - 1; i += 5) {
      pathScratch.addArc(
          Rect.fromCircle(center: points[i], radius: 10), 0, math.pi * 2);
    }

    // pega a diferenca entre o path do retangulo e o path dos circulos, e apenas
    // o conteudo do retangulo que não tiver circulos por cima que é exibido.
    final newPath =
        Path.combine(PathOperation.xor, pathBackground, pathScratch);

    // Desenha o path na tela
    canvas.drawPath(newPath, paint..blendMode);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
