import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/data/channel_provider.dart';
import 'package:racewerkconfigurator/data/data_point.dart';
import 'package:racewerkconfigurator/data/settings_provider.dart';
import 'package:racewerkconfigurator/usb/usb_data.dart';
import 'package:racewerkconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chart_button.dart';
import 'chart_drag_ball.dart';
import 'chart_painter.dart';

List<DataPoint> getMiddlePoints(List<DataPoint> dataPointList) {
  List<DataPoint> result = List.empty(growable: true);
  for (var i = 0; i < dataPointList.length - 1; i++) {
    result.add(DataPoint(
        x: (dataPointList[i].x + dataPointList[i + 1].x) / 2,
        y: (dataPointList[i].y + dataPointList[i + 1].y) / 2));
  }
  return result;
}

class Chart extends ConsumerWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelId = ref.watch(channelIdProvider);
    final settings = ref.watch(settingsProvider.notifier);
    final appSettings = ref.watch(settingsProvider);

    final usbStatus = ref.watch(usbProvider);
    // Todo: Make this more efficient
    var value = usbStatus.maybeWhen(
      data: (data) => data.maybeMap(
        connected: (usbStatus) =>
            parseValue(appSettings, usbStatus.currentValues, channelId),
        orElse: () => 0.0,
      ),
      orElse: () => 0.0,
    );

    value = value.clamp(0.0, 1.0);

    final axis = appSettings.channelSettings[channelId].profileAxis;
    final dataPoints = axis.dataPoints;
    const margin = 16.0;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: constraints.biggest.width,
        height: constraints.biggest.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(margin),
                color: const Color.fromRGBO(48, 48, 48, 1)),
            CustomPaint(
                painter: ChartPainter(axis, margin, value), child: Container()),
            ...dataPoints
                .asMap()
                .map((i, dataPoint) => MapEntry(
                    i,
                    DragBall(
                      dataPoint: dataPoint,
                      size: constraints.biggest,
                      margin: margin,
                      updateDataPoint: (newDataPoint) {
                        if (settings.mounted) {
                          settings.updateAxis(
                              axis.updateChartDataPoint(i, newDataPoint));
                        }
                      },
                      onPressed: () {
                        settings.updateAxis(
                            axis.deleteChartDataPointIfMoreThanTwo(i));
                      },
                    )))
                .values,
            ...getMiddlePoints(dataPoints)
                .asMap()
                .map((i, dp) => MapEntry(
                      i,
                      ChartButton(
                        dataPoint: dp,
                        size: constraints.biggest,
                        margin: margin,
                        text: "+",
                        onPressed: () {
                          settings.updateAxis(axis.addChartDataPointAfter(i));
                        },
                      ),
                    ))
                .values
          ],
        ),
      );
    });
  }
}
