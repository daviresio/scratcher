import 'package:flutter/material.dart';
import 'package:scratcher/helpers/image_helper.dart';
import 'package:scratcher/scratch_painter.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Offset> offsets = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<ui.Image>(
        future: ImageHelper.loadUiImage('assets/photo.jpg'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return GestureDetector(
            onPanUpdate: ((details) {
              setState(() {
                offsets.add(details.globalPosition);
              });
            }),
            child: CustomPaint(
              painter: ScractcherPainter(snapshot.data!, offsets),
            ),
          );
        },
      ),
    );
  }
}
