import 'package:budget_buddy/models/pie_data.dart';
import 'package:budget_buddy/models/transaction.dart';
import 'package:budget_buddy/screens/statistics/pie_chart.dart';
import 'package:budget_buddy/widgets/no_trancaction.dart';
import 'package:budget_buddy/widgets/transaction_list_items.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MonthlySpendings extends StatefulWidget {
  @override
  _MonthlySpendingsState createState() => _MonthlySpendingsState();
}

class _MonthlySpendingsState extends State<MonthlySpendings> {
  String _selectedYear = DateFormat('yyyy').format(DateTime.now());
  String dropdownValue = DateFormat('MMM').format(DateTime.now());

  bool _showChart = false;
  late Transactions trxData;
  late void Function(String) deleteFn;

  @override
  void initState() {
    super.initState();
    trxData = Provider.of<Transactions>(context, listen: false);
    deleteFn = trxData.deleteTransaction;
  }

  @override
  Widget build(BuildContext context) {
    final monthlyTrans = trxData.monthlyTransactions(dropdownValue, _selectedYear);
    final List<PieData> monthlyData = PieData.pieChartData(monthlyTrans);

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Theme.of(context).primaryColorLight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    dropDownToSelectMonth(),
                    widgetToSelectYear(),
                    Text(
                      "₹${trxData.getTotal(monthlyTrans)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
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
          monthlyTrans.isEmpty
              ? NoTransactions()
              : (_showChart
                  ? MyPieChart(pieData: monthlyData)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return TransactionListItems(
                            trx: monthlyTrans[index], dltTrxItem: deleteFn);
                      },
                      itemCount: monthlyTrans.length,
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
          onPressed: int.parse(_selectedYear) > 0
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

  DropdownButton<String> dropDownToSelectMonth() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.expand_more),
      elevation: 16,
      style: TextStyle(color: Theme.of(context).primaryColorDark),
      underline: Container(
        height: 2,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: const [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}