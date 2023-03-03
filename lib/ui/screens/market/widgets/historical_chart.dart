import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yahoofin/yahoofin.dart';
import 'package:date_format/date_format.dart';

class StockHistoricalChart extends StatefulWidget {
  const StockHistoricalChart({super.key, required this.stockChart});
  final StockChart stockChart;
  @override
  State<StockHistoricalChart> createState() => _StockHistoricalChartState();
}

class _StockHistoricalChartState extends State<StockHistoricalChart> {
  late StockChart stockChart;
  List<FlSpot> get lineChartData {
    List<FlSpot> spots = [];
    List<double> closeList = [];
    List<double> timeStamp = [];
    for (var value in stockChart.chartQuotes!.close!) {
      closeList.add(value.round().toDouble());
    }
    for (var value in stockChart.chartQuotes!.timestamp!) {
      timeStamp.add(value.toDouble());
    }

    for (int i = 0; i < (closeList.length - 1); i++) {
      spots.add(FlSpot(timeStamp[i], closeList[i]));
    }

    return spots;
  }

  List<double> get closeList {
    List<double> closeList = [];
    for (var value in stockChart.chartQuotes!.close!) {
      closeList.add(value.toDouble());
    }
    return closeList;
  }

  List<double> get timestampList {
    List<double> timeStamp = [];

    for (var value in stockChart.chartQuotes!.timestamp!) {
      timeStamp.add(value.toDouble());
    }
    return timeStamp;
  }

  @override
  void initState() {
    super.initState();
    stockChart = widget.stockChart;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: LineChart(
            mainData(),
          ),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          axisNameSize: 45,
          axisNameWidget: Row(
            children: [
              // space
              const SizedBox(
                width: 20,
              ),
              // minimum of close list
              RotatedBox(
                quarterTurns: 1,
                child: Text(closeList.reduce(min).toInt().toString()),
              ),
              // expand to  gather size
              const Spacer(),
              // maximum close list
              RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                      (((closeList.reduce(max) - closeList.reduce(min)) / 2) +
                              closeList.reduce(min).round())
                          .toInt()
                          .toString())),
              const Spacer(),
              RotatedBox(
                  quarterTurns: 1,
                  child: Text(closeList.reduce(max).toInt().toString()))
            ],
          ),
          //     sideTitles: SideTitles(
          //   reservedSize: 45,
          //   showTitles: true,
          //   interval: (closeList.reduce(max) - closeList.reduce(min)) / 2,
          // )
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: Row(
            children: [
              const SizedBox(
                width: 45,
              ),
              Text(formatDate(
                  DateTime.fromMillisecondsSinceEpoch(
                      timestampList.first.toInt() * 1000),
                  [d, ' ', M])),
              const Spacer(),
              Text(formatDate(
                  DateTime.fromMillisecondsSinceEpoch(
                      timestampList[timestampList.length ~/ 2].toInt() * 1000),
                  [d, ' ', M])),
              const Spacer(),
              Text(formatDate(DateTime.now(), [d, ' ', M]))
            ],
          ),
          axisNameSize: 20,
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: timestampList.first,
      maxX: timestampList.last,
      minY: closeList.reduce(min) * 0.98,
      maxY: closeList.reduce(max) * 1.02,
      lineBarsData: [
        LineChartBarData(
          spots: lineChartData,
          isCurved: false,
          color: closeList.last > closeList.first ? Colors.green : Colors.red,
          barWidth: 3,
          isStrokeCapRound: false,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                closeList.last > closeList.first ? Colors.green : Colors.red,
                closeList.last > closeList.first
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ].map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
