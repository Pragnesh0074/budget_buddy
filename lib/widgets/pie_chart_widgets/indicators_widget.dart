
import 'package:budget_buddy/models/pie_data.dart';
import 'package:flutter/material.dart';

class IndicatorsWidget extends StatelessWidget {
  final List<PieData> pieData;

  const IndicatorsWidget({
    Key? key,
    required this.pieData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: pieData
            .map(
              (data) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: buildIndicator(
                  color: data.color,
                  text: data.name,
                ),
              ),
            )
            .toList(),
      );

  Widget buildIndicator({
    required Color color,
    required String text,
    double size = 16,
    Color textColor = Colors.black,
  }) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}