import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:qlola_umkm/components/charts/pie/indicator.dart';

class PieChartComponent extends StatefulWidget {
  List products;

  PieChartComponent({super.key,
    required this.products
  });

  @override
  State<PieChartComponent> createState() => _PieChartComponentState();
}

class _PieChartComponentState extends State<PieChartComponent> {
  int touchedIndex = -1;

  int allQuantity = 0;

  List<PieChartSectionData> showingSections() {
    setState(() => allQuantity = 0);
    for (var element in widget.products) {
      setState(() => allQuantity += int.parse(element["quantity"].toString()));
    }
    return List.generate(widget.products.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: Color.fromARGB((255 / (index + 1)).round(), 192, 42, 52),
        value: int.parse(widget.products[index]["quantity"].toString()) * 100 / allQuantity,
        title: "${int.parse(widget.products[index]["quantity"].toString()) * 100 / allQuantity}%",
        borderSide: BorderSide(width: 1, color: Colors.white),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColorDark
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 80),
      child: Row(
        children: [
          Expanded(child: AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              swapAnimationDuration: Duration(milliseconds: 150),
              swapAnimationCurve: Curves.linear,
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  }
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: showingSections()
              )
            )
          )),
          const SizedBox(width: 40),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < widget.products.length; index++) Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: Indicator(
                  color: Color.fromARGB((255 / (index + 1)).round(), 192, 42, 52),
                  text: widget.products[index]["product_name"],
                  isSquare: true,
                )
              )
            ]
          ))
        ]
      )
    );
  }
}