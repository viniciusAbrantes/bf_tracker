import 'package:bf_tracker/models/body_fat_log.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants/strings.dart';

class LogLineChart extends StatelessWidget {
  final Future<List<BodyFatLog>> logs;

  const LogLineChart(this.logs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: logs,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.length < 2) {
            return const Center(child: Text(Strings.insufficientData));
          }
          return LineChart(
            LineChartData(
                titlesData: const FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: snapshot.data!
                        .mapIndexed((index, element) =>
                            FlSpot(index.toDouble(), element.fatPercentage))
                        .toList(),
                    isCurved: false,
                    dotData: const FlDotData(show: true),
                  )
                ]),
          );
        },
      ),
    );
  }
}
