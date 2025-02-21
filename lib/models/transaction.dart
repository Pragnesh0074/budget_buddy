import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../DBhelp/dbhelper.dart';

class Transaction {
  final String id;
  final String title;
  final int amount;
  final DateTime date;
  final String category;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => [..._transactions];

  int getTotal(List<Transaction> transaction) {
    return transaction.fold(0, (sum, item) => sum + item.amount);
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
    DBHelper.insert(transaction);
  }

  List<Transaction> filterTransactions(String Function(Transaction) filter) {
    return _transactions.where((trx) => filter(trx) == 'true').toList();
  }

  List<Transaction> monthlyTransactions(String month, String year) {
    return _transactions.where((trx) =>
      DateFormat('yyyy').format(trx.date) == year &&
      DateFormat('MMM').format(trx.date) == month).toList();
  }

  List<Transaction> yearlyTransactions(String year) {
    return _transactions.where((trx) => DateFormat('yyyy').format(trx.date) == year).toList();
  }

  List<Transaction> dailyTransactions() {
    return _transactions.where((trx) =>
      trx.date.day == DateTime.now().day &&
      trx.date.month == DateTime.now().month &&
      trx.date.year == DateTime.now().year).toList();
  }

  List<Transaction> get recentTransactions => _transactions.where((tx) =>
    tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)))).toList();

  Future<void> fetchTransactions() async {
    final fetchedData = await DBHelper.fetch();
    _transactions = fetchedData.map((item) => Transaction(
      id: item['id'],
      title: item['title'],
      amount: item['amount'],
      date: DateTime.parse(item['date']),
      category: item['category'],
    )).toList();
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((item) => item.id == id);
    notifyListeners();
    DBHelper.delete(id);
  }

  List<Map<String, Object>> firstSixMonthsTransValues(
      List<Transaction> trans, int year) {
        
    return List.generate(6, (index) {
      List<int> months = [
        DateTime.january,
        DateTime.february,
        DateTime.march,
        DateTime.april,
        DateTime.may,
        DateTime.june,
      ];
      List<String> monthsTitle = [
        'january',
        'february',
        'march',
        'april',
        'may',
        'june',
      ];
      final perMonth = months[index];
      final perMonthTitle = monthsTitle[index];
      var totalSum = 0;
      for (var i = 0; i < trans.length; i++) {
        if (trans[i].date.month == perMonth && trans[i].date.year == year) {
          totalSum += trans[i].amount;
        }
      }

      return {
        'amount': totalSum.toDouble(),
        'month': perMonthTitle,
      };
    });
  }

  List<Map<String, Object>> lastSixMonthsTransValues(
      List<Transaction> trans, int year) {
    return List.generate(6, (index) {
      List<int> months = [
        DateTime.july,
        DateTime.august,
        DateTime.september,
        DateTime.october,
        DateTime.november,
        DateTime.december,
      ];
      List<String> monthsTitle = [
        'july',
        'august',
        'september',
        'october',
        'november',
        'december',
      ];
      final perMonth = months[index];
      final perMonthTitle = monthsTitle[index];
      var totalSum = 0;
      for (var i = 0; i < trans.length; i++) {
        if (trans[i].date.month == perMonth && trans[i].date.year == year) {
          totalSum += trans[i].amount;
        }
      }

      return {
        'amount': totalSum.toDouble(),
        'month': perMonthTitle,
      };
    });
  }



}
