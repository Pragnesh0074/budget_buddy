import 'package:budget_buddy/models/transaction.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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

  static List<PieData> pieChartData(List<Transaction> trx) {
    int total = Transactions().getTotal(trx);
    List<Map<String, dynamic>> finalData = sortedPieData(trx);
    final List<Color> predefinedColors = [
      Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple,
      Colors.teal, Colors.pink, Colors.yellow, Colors.brown, Colors.cyan
    ];
    final Random random = Random();

    return finalData.map((element) {
      Color color = predefinedColors[random.nextInt(predefinedColors.length)];
      return PieData(
        name: element['title'] as String,
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