import 'package:flutter/material.dart';

class NoTransactions extends StatelessWidget {
  const NoTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset(
          'assets/images/waiting.png',
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 10),
        const Text(
          'No data available!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
