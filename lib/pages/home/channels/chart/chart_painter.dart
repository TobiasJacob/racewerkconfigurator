import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';

class ChartPainter extends CustomPainter {
  final ProfileAxis axis;
  final double margin;
  final double currentValue;

  ChartPainter(this.axis, this.margin, this.currentValue);

  @override
  void paint(Canvas canvas, Size size) {
    final dataPoints = axis.dataPoints;
    final width = size.width - 2 * margin;
    final height = size.height - 2 * margin;

    // Draw Graph
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    Offset p1 = Offset(0.0, (1 - dataPoints[0].y) * height + margin);
    Offset p2 = Offset(dataPoints[0].x * width + margin,
        (1.0 - dataPoints[0].y) * height + margin);
    canvas.drawLine(p1, p2, paint);
    for (var i = 0; i < dataPoints.length - 1; i++) {
      p1 = Offset(dataPoints[i].x * width + margin,
          (1.0 - dataPoints[i].y) * height + margin);
      p2 = Offset(dataPoints[i + 1].x * width + margin,
          (1.0 - dataPoints[i + 1].y) * height + margin);
      canvas.drawLine(p1, p2, paint);
    }
    final i = dataPoints.length - 1;
    p1 = Offset(dataPoints[i].x * width + margin,
        (1.0 - dataPoints[i].y) * height + margin);
    p2 =
        Offset(1.0 * width + margin, (1.0 - dataPoints[i].y) * height + margin);
    canvas.drawLine(p1, p2, paint);

    // Draw Value Line
    paint = Paint()
      ..color = const Color.fromRGBO(80, 254, 0, 1)
      ..strokeWidth = 2;
    final x = currentValue.clamp(0.0, 1.0);
    p1 = Offset(x * width + margin, margin);
    p2 = Offset(x * width + margin, height + margin);
    canvas.drawLine(p1, p2, paint);
    final y = axis.getY(x).clamp(0.0, 1.0);
    p1 = Offset(margin, height * (1.0 - y) + margin);
    p2 = Offset(width + margin, height * (1.0 - y) + margin);
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
