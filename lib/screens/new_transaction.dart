import 'package:budget_buddy/constants/categories.dart';
import 'package:budget_buddy/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class NewTransaction extends StatefulWidget {
  static const routeName = '/new-transaction';
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final inputTitleController = TextEditingController();
  final inputAmountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  late Transactions transactions;
  String dropdownValue = 'Other';

  void chooseDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    transactions = Provider.of<Transactions>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Add Transaction",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            right: 20,
            left: 20,
            top: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Title"),
                controller: inputTitleController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: "Amount"),
                controller: inputAmountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              dropDownToSelectCategory(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: chooseDate,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        "Choose Date",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Text(
                    DateFormat.yMMMd().format(_selectedDate),
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                child: const Text("Add"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: _addTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDownToSelectCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
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
          items: categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _addTransaction() {
    FocusScope.of(context).unfocus();
    if (inputTitleController.text.isNotEmpty &&
        int.tryParse(inputAmountController.text) != null &&
        // ignore: unnecessary_null_comparison
        _selectedDate != null) {
      final enteredTitle = inputTitleController.text;
      final enteredAmount = int.parse(inputAmountController.text);

      transactions.addTransaction(
        Transaction(
          id: DateTime.now().toString(),
          title: enteredTitle,
          amount: enteredAmount,
          date: _selectedDate,
          category: dropdownValue,
        ),
      );
      inputTitleController.clear();
      inputAmountController.clear();
      setState(() {
        dropdownValue = 'Other';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          content: const Text(
            "Data added Successfully!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            "Fields can't be empty!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
