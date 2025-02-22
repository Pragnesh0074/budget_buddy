import 'package:budget_buddy/models/pie_data.dart';
import 'package:budget_buddy/models/transaction.dart';
import 'package:budget_buddy/screens/statistics/pie_chart.dart';
import 'package:budget_buddy/screens/statistics/weekly_stats.dart';
import 'package:budget_buddy/widgets/no_trancaction.dart';
import 'package:budget_buddy/widgets/transaction_list_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeeklySpendings extends StatefulWidget {
  @override
  _WeeklySpendingsState createState() => _WeeklySpendingsState();
}

class _WeeklySpendingsState extends State<WeeklySpendings> {
  bool _showChart = false;
  late Transactions trxData;

  @override
  void initState() {
    super.initState();
    trxData = Provider.of<Transactions>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final deleteFn =
        Provider.of<Transactions>(context, listen: false).deleteTransaction;
    final recentTransaction =
        Provider.of<Transactions>(context).recentTransactions;
    final recentData = PieData.pieChartData(recentTransaction);

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Container(
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
                        "₹${trxData.getTotal(recentTransaction)}",
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
                        inactiveTrackColor: Colors.blueAccent,
                        activeTrackColor: Colors.blueAccent,
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
          ),
          recentTransaction.isEmpty
              ? Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.2,
                ),
                child: const NoTransactions(),
              )
              : (_showChart
                  ? WeeklyChart(
                    recentTransaction: recentTransaction,
                    recentData: recentData,
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return TransactionListItems(
                        trx: recentTransaction[index],
                        dltTrxItem: deleteFn,
                      );
                    },
                    itemCount: recentTransaction.length,
                  )),
        ],
      ),
    );
  }
}

class WeeklyChart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  final List<PieData> recentData;

  const WeeklyChart({
    Key? key,
    required this.recentTransaction,
    required this.recentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: MyPieChart(pieData: recentData),
        ),
        WeeklyStats(recentTransactions: recentTransaction),
      ],
    );
  }
}
