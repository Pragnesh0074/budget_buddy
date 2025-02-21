import 'package:budget_buddy/models/pie_data.dart';
import 'package:budget_buddy/models/transaction.dart';
import 'package:budget_buddy/screens/statistics/pie_chart.dart';
import 'package:budget_buddy/widgets/no_trancaction.dart';
import 'package:budget_buddy/widgets/transaction_list_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DailySpendings extends StatefulWidget {
  @override
  _DailySpendingsState createState() => _DailySpendingsState();
}

class _DailySpendingsState extends State<DailySpendings> {

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
    final dailyTrans = Provider.of<Transactions>(context).dailyTransactions();
    final List<PieData> dailyData = PieData.pieChartData(dailyTrans);

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Theme.of(context).primaryColorLight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "₹${trxData.getTotal(dailyTrans)}",
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
          dailyTrans.isEmpty
              ? NoTransactions()
              : (_showChart
                  ? MyPieChart(pieData: dailyData)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return TransactionListItems(
                            trx: dailyTrans[index], dltTrxItem: deleteFn);
                      },
                      itemCount: dailyTrans.length,
                    )),
        ],
      ),
    );
  }
}
