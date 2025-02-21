import 'package:budget_buddy/models/pie_data.dart';
import 'package:budget_buddy/models/transaction.dart';
import 'package:budget_buddy/screens/statistics/pie_chart.dart';
import 'package:budget_buddy/screens/statistics/yearly_stats.dart';
import 'package:budget_buddy/widgets/no_trancaction.dart';
import 'package:budget_buddy/widgets/transaction_list_items.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class YearlySpendings extends StatefulWidget {
  @override
  _YearlySpendingsState createState() => _YearlySpendingsState();
}

class _YearlySpendingsState extends State<YearlySpendings> {
  String _selectedYear = DateFormat('yyyy').format(DateTime.now());
  bool _showChart = false;
  late Transactions trxData;

  @override
  void initState() {
    super.initState();
    trxData = Provider.of<Transactions>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final deleteFn = Provider.of<Transactions>(context).deleteTransaction;
    final yearlyTrans = trxData.yearlyTransactions(_selectedYear);
    final yearlyData = PieData.pieChartData(yearlyTrans);
    final groupTransFirstSixMonths = trxData.firstSixMonthsTransValues(yearlyTrans, int.parse(_selectedYear));
    final groupTransLastSixMonths = trxData.lastSixMonthsTransValues(yearlyTrans, int.parse(_selectedYear));

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Theme.of(context).primaryColorLight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widgetToSelectYear(),
                    Text(
                      "₹${trxData.getTotal(yearlyTrans)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Show Chart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.secondary,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          yearlyTrans.isEmpty
              ? const NoTransactions()
              : (_showChart
                  ? yearlyChart(yearlyData, groupTransFirstSixMonths, groupTransLastSixMonths)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return TransactionListItems(
                            trx: yearlyTrans[index], dltTrxItem: deleteFn);
                      },
                      itemCount: yearlyTrans.length,
                    )),
        ],
      ),
    );
  }

  Row widgetToSelectYear() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: int.parse(_selectedYear) > 2000
              ? () {
                  setState(() {
                    _selectedYear = (int.parse(_selectedYear) - 1).toString();
                  });
                }
              : null,
        ),
        Text(_selectedYear),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: _selectedYear == DateFormat('yyyy').format(DateTime.now())
              ? null
              : () {
                  setState(() {
                    _selectedYear = (int.parse(_selectedYear) + 1).toString();
                  });
                },
        ),
      ],
    );
  }

  Column yearlyChart(List<PieData> yearlyData, List<Map<String, Object>> firstSixMonths, List<Map<String, Object>> lastSixMonths) {
    return Column(
      children: [
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          color: Theme.of(context).primaryColorDark,
          child: MyPieChart(pieData: yearlyData),
        ),
        YearlyStats(groupedTransactionValues: firstSixMonths),
        YearlyStats(groupedTransactionValues: lastSixMonths),
      ],
    );
  }
}
