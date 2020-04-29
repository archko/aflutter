import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Point {
  double x;
  double y;

  Point({this.x, this.y});
}

class BesselViewPainter extends CustomPainter {
  final double radius;
  final double M = 0.551915024494;
  final double percent;
  final bool isToRight;
  final Color color;

  BesselViewPainter(
      {@required this.radius,
      @required this.percent,
      @required this.isToRight,
      @required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final curvePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = this.color;

    final curvePath = Path();
    _canvasBesselPath(curvePath);
    canvas.drawPath(curvePath, curvePaint);
  }

  void _canvasBesselPath(Path path) {
    Point p1 = Point(x: radius * 2, y: radius);
    Point p2 = Point(x: radius, y: radius * 2);
    Point p3 = Point(x: 0, y: radius);
    Point p4 = Point(x: radius, y: 0);

    if (isToRight) {
      if (percent <= 0.2) {
        p1.x = radius * 2 + radius * percent / 0.2;
      } else if (percent <= 0.4) {
        p4.x = p2.x = radius + radius * (percent - 0.2) / 0.2;
        p1.x = p2.x + radius * 2;
      } else if (percent <= 0.6) {
        p3.x = radius * (percent - 0.4) / 0.2;
        p4.x = p2.x = p3.x + radius * 2;
        p1.x = radius * 4;
      } else if (percent <= 0.8) {
        p3.x = radius + radius * (percent - 0.6) / 0.2;
        p4.x = p2.x = radius * 3;
        p1.x = radius * 4;
      } else if (percent <= 0.9) {
        p3.x = 2 * radius + radius * (percent - 0.8) / 0.3;
        p4.x = p2.x = radius * 3;
        p1.x = radius * 4;
      } else if (percent <= 1.0) {
        p3.x = 2 * radius + radius * (1 - percent) / 0.3;
        p4.x = p2.x = radius * 3;
        p1.x = radius * 4;
      }
    } else {
      if (percent <= 0.2) {
        p3.x = -radius * percent / 0.2;
      } else if (percent <= 0.4) {
        p3.x = -radius - radius * (percent - 0.2) / 0.2;
        p4.x = p2.x = p3.x + 2 * radius;
      } else if (percent <= 0.6) {
        p3.x = -2 * radius;
        p4.x = p2.x = -radius * (percent - 0.4) / 0.2;
        p1.x = p2.x + radius * 2;
      } else if (percent <= 0.8) {
        p3.x = -2 * radius;
        p4.x = p2.x = -radius;
        p1.x = p2.x + radius * 2 - radius * (percent - 0.6) / 0.2;
      } else if (percent <= 0.9) {
        p3.x = -2 * radius;
        p4.x = p2.x = -radius;
        p1.x = p2.x + radius - radius * (percent - 0.8) / 0.4;
      } else if (percent <= 1.0) {
        p3.x = -2 * radius;
        p4.x = p2.x = -radius;
        p1.x = p2.x + radius - radius * (1 - percent) / 0.4;
      }
    }

    final p1Radius = p2.y - p1.y;
    final p24LeftRadius = p2.x - p3.x;
    final p24RightRadius = p1.x - p2.x;
    final p3Radius = p2.y - p3.y;
    path.moveTo(p1.x, p1.y);
    path.cubicTo(
        p1.x, p1.y + p1Radius * M, p2.x + p24RightRadius * M, p2.y, p2.x, p2.y);
    path.cubicTo(
        p2.x - p24LeftRadius * M, p2.y, p3.x, p3.y + p3Radius * M, p3.x, p3.y);
    path.cubicTo(
        p3.x, p3.y - p3Radius * M, p4.x - p24LeftRadius * M, p4.y, p4.x, p4.y);
    path.cubicTo(
        p4.x + p24RightRadius * M, p4.y, p1.x, p1.y - p1Radius * M, p1.x, p1.y);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
