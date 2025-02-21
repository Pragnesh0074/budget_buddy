
import 'package:budget_buddy/models/pie_data.dart';
import 'package:budget_buddy/widgets/pie_chart_widgets/indicators_widget.dart';
import 'package:budget_buddy/widgets/pie_chart_widgets/pie_chart_sections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatefulWidget {
  final List<PieData> pieData;

  const MyPieChart({
    Key? key,
    required this.pieData,
  }) : super(key: key);

  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 0.95,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (event is FlLongPressEnd || event is FlPanEndEvent) {
                        touchedIndex = -1;
                      } else {
                        touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
                      }
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: getSections(touchedIndex, widget.pieData, screenWidth),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: IndicatorsWidget(
              pieData: widget.pieData,
            ),
          ),
        ],
      ),
    );
  }
}