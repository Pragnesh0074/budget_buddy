import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class YearlyStats extends StatefulWidget {
  final List<Map<String, Object>> groupedTransactionValues;

  const YearlyStats({
    Key? key,
    required this.groupedTransactionValues,
  }) : super(key: key);

  @override
  _YearlyStatsState createState() => _YearlyStatsState();
}

class _YearlyStatsState extends State<YearlyStats> {
  late int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: Theme.of(context).primaryColorDark,
          ),
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Analysis',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Monthly Analysis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    mainBarData(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Text(
                widget.groupedTransactionValues[value.toInt()]['month']
                    .toString()
                    .substring(0, 3),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: widget.groupedTransactionValues
          .asMap()
          .entries
          .map((entry) => _buildBar(entry.key, entry.value['amount'] as double))
          .toList(),
    );
  }

  BarChartGroupData _buildBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Theme.of(context).primaryColor,
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
