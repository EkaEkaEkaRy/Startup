import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:http/http.dart' as http;
import 'package:startup/api/api.dart';
import 'package:image/image.dart' as img;

Future<XFile> drawOutputImage(XFile inputFile, List trackJson) async {
  final bytes = await inputFile.readAsBytes();
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  final ui.FrameInfo frame = await codec.getNextFrame();
  final ui.Image image = frame.image;

  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder);

  File imageFile = File(inputFile.path);
  img.Image? imageTemp = img.decodeImage(imageFile.readAsBytesSync());

  // Масштабирование изображения
  final scaleFactor = getScaleFactor(
      image, Size(imageTemp!.width.toDouble(), imageTemp.height.toDouble()));

  // Рисование исходного изображения
  canvas.drawImage(
    image,
    Offset.zero,
    Paint()..filterQuality = FilterQuality.high,
  );

  // Рисование результатов распознавания
  for (var trackResult in trackJson) {
    final box = trackResult['box'];
    final name = trackResult['name'];
    final confidence = trackResult['confidence'];

    // Масштабирование координат
    final x1 = box['x1'] * scaleFactor;
    final y1 = box['y1'] * scaleFactor;
    final x2 = box['x2'] * scaleFactor;
    final y2 = box['y2'] * scaleFactor;

    // Рисование прямоугольника
    canvas.drawRect(
      Rect.fromLTWH(x1, y1, x2 - x1, y2 - y1),
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    // Рисование текста (название и вероятность)
    drawText(
        canvas, '${name} ${confidence.toStringAsFixed(2)}', Offset(x1, y1));

    // Получение цены
    final price = await Apiservice().getPrice(name);

    // Рисование текста (цена)
    drawText(canvas, 'Цена $price рублей', Offset(x1, y2));
  }

  // Получение изображения из canvas
  final picture = pictureRecorder.endRecording();
  final ui.Image drawnImage = await picture.toImage(image.width, image.height);

  // Сохранение изображения в файл
  final newBytes = await drawnImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List byteList = newBytes!.buffer.asUint8List();

  // Сохранение изображения в файл с уникальным именем
  final directory = await getApplicationDocumentsDirectory();
  final outputFile = File(
      '${directory.path}/output_${DateTime.now().millisecondsSinceEpoch}.png');

  await outputFile.writeAsBytes(byteList);

  return XFile(outputFile.path);
}

// Функция для рисования текста
void drawText(Canvas canvas, String text, Offset offset) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  textPainter.paint(canvas, offset);
}

// Масштабирование изображения
double getScaleFactor(ui.Image image, Size canvasSize) {
  return image.width > image.height
      ? canvasSize.width / image.width
      : canvasSize.height / image.height;
}
