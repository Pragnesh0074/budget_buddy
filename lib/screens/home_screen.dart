import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import './transactions/daily_spendings.dart';
import './transactions/monthly_spendings.dart';
import './transactions/yearly_spendings.dart';
import './new_transaction.dart';
import './transactions/weekly_spendings.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Budget Buddy",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(NewTransaction.routeName),
          ),
        ],
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          indicatorColor: Theme.of(context).primaryColorDark,
          tabs: const [
            Tab(text: "Daily"),
            Tab(text: "Weekly"),
            Tab(text: "Monthly"),
            Tab(text: "Yearly"),
          ],
          controller: tabController,
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<Transactions>(context, listen: false).fetchTransactions(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return TabBarView(
              controller: tabController,
              children: [
                DailySpendings(),
                WeeklySpendings(),
                MonthlySpendings(),
                YearlySpendings(),
              ],
            );
          }
        },
      ),
    );
  }
}
