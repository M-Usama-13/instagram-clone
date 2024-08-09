import 'package:flutter/material.dart';

class StatColumn extends StatefulWidget {
  final int num;
  final String label;
  const StatColumn({Key? key, required this.num, required this.label}) : super(key: key);

  @override
  State<StatColumn> createState() => _StatColumnState();
}

class _StatColumnState extends State<StatColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.num.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),Text(
          widget.label.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
