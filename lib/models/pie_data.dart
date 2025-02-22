import 'package:budget_buddy/models/transaction.dart';
import 'package:flutter/material.dart';

class PieData {
  final String name;
  final double percent;
  final Color color;
  final int price;

  const PieData({
    required this.name,
    required this.percent,
    required this.color,
    required this.price,
  });

  // Define a map of categories to specific colors
  static final Map<String, Color> categoryColors = {
    'Food': Colors.orange,
    'Social Life': Colors.purple,
    'Self-development': Colors.blue,
    'Transportation': Colors.green,
    'Culture': Colors.red,
    'Household': Colors.teal,
    'Apparel': Colors.pink,
    'Beauty': Colors.amber,
    'Health': Colors.lightBlue,
    'Education': Colors.indigo,
    'Gift': Colors.deepPurple,
    'Other': Colors.grey,
  };

  static List<PieData> pieChartData(List<Transaction> trx) {
    int total = Transactions().getTotal(trx);
    List<Map<String, dynamic>> finalData = sortedPieData(trx);

    return finalData.map((element) {
      String category = element['title'] as String;
      // Use the predefined color for the category, fallback to grey if category not found
      Color color = categoryColors[category] ?? Colors.grey;

      return PieData(
        name: category,
        percent: (((element['amount'] as int) * 100) / total).roundToDouble(),
        color: color,
        price: element['amount'] as int,
      );
    }).toList();
  }

  static List<Map<String, dynamic>> sortedPieData(List<Transaction> trx) {
    List<Map<String, dynamic>> finalList = [];

    for (var transaction in trx) {
      var index = finalList.indexWhere((element) => element['title'] == transaction.category);
      if (index != -1) {
        finalList[index]['amount'] = (finalList[index]['amount'] as int) + transaction.amount;
      } else {
        finalList.add({
          'title': transaction.category,
          'amount': transaction.amount,
        });
      }
    }
    return finalList;
  }
}