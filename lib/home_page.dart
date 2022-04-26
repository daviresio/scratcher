import 'dart:async';

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
  final List<List<Offset>> offsetsList = [];
  final offsetsStream = StreamController<List<List<Offset>>>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<ui.Image>(
        future: ImageHelper.loadUiImage('assets/photo.jpg'),
        builder: (context, imageLoaded) {
          if (!imageLoaded.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: GestureDetector(
              onPanStart: (details) {
                offsetsList.add([details.localPosition]);
              },
              onPanUpdate: ((details) {
                offsetsList.last.add(details.localPosition);
                offsetsStream.add(offsetsList);
              }),
              child: StreamBuilder<List<List<Offset>>>(
                  stream: offsetsStream.stream,
                  builder: (context, snapshot) {
                    return CustomPaint(
                      size: const Size(200, 200),
                      painter: ScractcherPainter(
                        imageLoaded.data!,
                        snapshot.data ?? [],
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
