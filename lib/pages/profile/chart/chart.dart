import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis_view_provider.dart';
import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/app_settings.dart';
import '../../../data/profile.dart';
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
    final channelsSettings = ref.watch(settingsProvider.select((value) => value.channelSettings));
    final axisId = ref.watch(axisIdProvider);
    final axis = ref.watch(axisProvider);
    final settings = ref.watch(settingsProvider.notifier);

    final usbStatus = ref.watch(usbProvider);
    // Todo: Make this more efficient
    var channelIndex = -1;
    for (var i = 0; i < channelsSettings.length; i++) {
      if (channelsSettings[i].usage == axisId) {
        channelIndex = i;
        break;
      }
    }
    var value = 0.0;
    if (channelIndex >= 0) {
      var channelSettings = channelsSettings[channelIndex];
      final usbValue = usbStatus.maybeWhen(
        data: (data) => data.maybeMap(
          connected: (usbStatus) => usbStatus.currentValues[channelIndex],
          orElse: () => 0,
        ),
        orElse: () => 0,
      );
      value = (usbValue - channelSettings.minValue) /
          (channelSettings.maxValue - channelSettings.minValue);
    }

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
                margin: const EdgeInsets.all(margin), color: Colors.grey[300]),
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
                        settings
                            .updateAxis(axis.deleteChartDataPointIfMoreThanTwo(i));
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
                          settings
                            .updateAxis(axis.addChartDataPointAfter(i));
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
