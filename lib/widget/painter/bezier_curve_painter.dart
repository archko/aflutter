import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class BezierCurvePainter extends CustomPainter {
  final double moveForward;
  final TextStyle textStyle;
  final double circleStrokeWidth;
  final Color strokeCircleColor;
  final double percentage;
  final double moveForwardLight;
  final Picture darkWavePic;
  final Picture lightWavePic;
  final double waterHeight;
  final Paint _paints = Paint();

  BezierCurvePainter({
    @required this.moveForward,
    @required this.strokeCircleColor,
    @required this.textStyle,
    @required this.circleStrokeWidth,
    @required this.percentage,
    @required this.moveForwardLight,
    @required this.darkWavePic,
    @required this.lightWavePic,
    @required this.waterHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint layerPaint = new Paint();

    double halfSizeHeight = size.height / 2;
    double halfSizeWidth = size.width / 2;
    double radius = min(size.width, size.height) / 2 - circleStrokeWidth / 2;

    //由于在绘制图片的时候在波浪上面有50%高度的空白部分，所以在这里必须减掉
    double targetHeight = waterHeight - halfSizeHeight;

    canvas.saveLayer(
        new Rect.fromLTRB(0.0, 0.0, size.width, size.height), layerPaint);
    //绘制淡颜色的海浪
    canvas.save();
    canvas.translate(moveForwardLight, targetHeight);
    canvas.drawPicture(lightWavePic);

    //绘制深颜色的海浪
    double moveDistance = moveForward - moveForwardLight;
    canvas.translate(moveDistance, 0.0);
    canvas.drawPicture(darkWavePic);
    canvas.restore();

    layerPaint.blendMode = BlendMode.dstIn;
    canvas.saveLayer(
        new Rect.fromLTRB(0.0, 0.0, size.width, size.height), layerPaint);

    canvas.drawCircle(new Offset(halfSizeWidth, halfSizeHeight),
        radius - circleStrokeWidth, _paints);
    canvas.restore();
    canvas.restore();

    _paints.style = PaintingStyle.stroke;
    _paints.color = strokeCircleColor;
    _paints.strokeWidth = circleStrokeWidth;
    canvas.drawCircle(
        new Offset(halfSizeWidth, halfSizeHeight), radius, _paints);

    TextPainter textPainter = new TextPainter();
    textPainter.textDirection = TextDirection.ltr;
    textPainter.text = new TextSpan(
      text: (percentage * 100).toInt().toString() + "%",
      style: textStyle,
    );
    textPainter.layout();
    double textStarPositionX = halfSizeWidth - textPainter.size.width / 2;
    double textStarPositionY = halfSizeHeight - textPainter.size.height / 2;
    textPainter.paint(canvas, new Offset(textStarPositionX, textStarPositionY));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
