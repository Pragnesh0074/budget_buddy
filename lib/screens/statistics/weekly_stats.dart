import 'package:budget_buddy/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyStats extends StatefulWidget {
  final List<Transaction> recentTransactions;

  const WeeklyStats({Key? key, required this.recentTransactions})
    : super(key: key);

  @override
  _WeeklyStatsState createState() => _WeeklyStatsState();
}

class _WeeklyStatsState extends State<WeeklyStats> {
  late int touchedIndex;

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = widget.recentTransactions
          .where(
            (trx) =>
                trx.date.day == weekDay.day &&
                trx.date.month == weekDay.month &&
                trx.date.year == weekDay.year,
          )
          .fold(0, (sum, item) => sum + item.amount);

      return {
        'date': DateFormat.d().format(weekDay),
        'amount': totalSum.toDouble(),
        'day': DateFormat.EEEE().format(weekDay),
      };
    }).reversed.toList();
  }

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
                'Last Seven Days',
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
                  child: BarChart(mainBarData()),
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
        tooltipBgColor: Colors.blueGrey
        // tooltipDecoration: BoxDecoration(
        //   color: Colors.blueGrey,
        //   borderRadius: BorderRadius.circular(4),
        // ),
      ),
    ),
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text(
              groupedTransactionValues[value.toInt()]['date'].toString(),
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
    barGroups: groupedTransactionValues
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
