import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

extension UtilListExtension on List{
  groupBy(String key) {
    try {
      List<Map<String, dynamic>> result = [];
      List<String> keys = [];

      this.forEach((f) => keys.add(f[key]));

      [...keys.toSet()].forEach((k) {
        List data = [...this.where((e) => e[key] == k)];
        result.add({k: data});
      });

      return result;
    } catch (e, s) {
      // printCatchNReport(e, s);
      return this;
    }
  }
}

class LineChartComponent extends StatefulWidget {
  Map<String, dynamic> report;

  LineChartComponent({super.key,
    required this.report
  });

  @override
  State<LineChartComponent> createState() => _LineChartComponentState();
}

class _LineChartComponentState extends State<LineChartComponent> {
  List transactions = [];
  List<FlSpot> flSpot = [];
  num totalMax = 0;

  List<Color> gradientColors = [
    Colors.red,
    Colors.red.withOpacity(0.8),
  ];

  bool showAvg = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      setState(() => transactions = widget.report["transactions"]);
      setState(() => transactions = transactions.map((a) => {...a, "created_at": a["created_at"].toString().split(" ")[0]}).toList());
      setState(() => transactions = transactions.groupBy("created_at"));

      List<FlSpot> ls = [];
      num max = 0;

      for (var trns in transactions) {
        var index = transactions.indexOf(trns);
        var key = transactions[index].keys.first;
        final total = transactions[index][key].map((item) => item["grand_total"]).reduce((a, b) => a + b);


        if ((index - 1) < 0) {
          ls.add(
            FlSpot(
              0,
              double.parse(total.toString()) / 1000)
          );
        } else {
          ls.add(
            FlSpot(
              double.parse(max.toString()) / 1000,
              double.parse(total.toString()) / 1000
            )
          );
        }
        
        max = total;
      }

      setState(() {
        flSpot = ls;
        totalMax = max;
      });

      inspect(flSpot);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 28,
          top: 22,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              if (transactions.isNotEmpty) LineChartBarData(
                // spots: [
                //   FlSpot(0, 100.0),
                //   FlSpot(100.0, 200.0),
                //   FlSpot(200.0, 200.0),
                //   // FlSpot(4, 4),
                //   // FlSpot(5, 6),
                //   // FlSpot(6, 200),
                //   // FlSpot(7, 6),
                //   // FlSpot(8, 4),
                //   // FlSpot(9, 6),
                //   // FlSpot(10, 6),
                //   // FlSpot(11, 7),
                // ],
                spots: flSpot,
                isCurved: true,
                barWidth: 8,
                color: Colors.green,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.green,
                  cutOffY: 0,
                  applyCutOffY: true,
                ),
                aboveBarData: BarAreaData(
                  show: true,
                  color: Colors.green,
                  cutOffY: 0,
                  applyCutOffY: true,
                ),
                dotData: const FlDotData(
                  show: false,
                ),
              ),
            ],
            minY: 0,
            maxY: double.parse(totalMax.toString()) / 300,
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  // reservedSize: 18,
                  reservedSize: 1,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                axisNameSize: 20,
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  // reservedSize: 40,
                  reservedSize: 1,
                  getTitlesWidget: leftTitleWidgets,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.black
              )
            ),
            gridData: FlGridData(
              show: false,
              drawVerticalLine: false,
              horizontalInterval: 1
            )
          )
        )
      )
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text = "";

    if (transactions.isNotEmpty && value.toInt() < transactions.length) {
      for (var index = 0; index < flSpot.length; index++) {
        if (value.toInt() == index) {
          text = transactions[value.toInt()].keys.first;
          break;
        }
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.green,
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      // child: Text('\$ ${value + 0.5}', style: style),
      child: Text('', style: style),
    );
  }
}