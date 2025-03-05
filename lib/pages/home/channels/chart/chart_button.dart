import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/data/data_point.dart';

class ChartButton extends StatelessWidget {
  final DataPoint dataPoint;
  final Size size;
  final String text;
  final double margin;
  final Function() onPressed;
  final Offset? offset;

  const ChartButton(
      {Key? key,
      required this.dataPoint,
      required this.size,
      required this.margin,
      required this.text,
      required this.onPressed,
      this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const buttonWidth = 48.0;
    const buttonHeight = 24.0;
    final width = size.width - 2.0 * margin;
    final height = size.height - 2.0 * margin;
    return Positioned(
      left: dataPoint.x * width -
          buttonWidth / 2.0 +
          margin +
          (offset?.dx ?? 0.0),
      bottom: dataPoint.y * height -
          buttonHeight / 2.0 +
          margin +
          (offset?.dy ?? 0.0),
      width: buttonWidth,
      height: buttonHeight,
      child: MaterialButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        color: const Color.fromRGBO(185, 101, 254, 1),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: 0,
        child: Text(text),
      ),
    );
  }
}
