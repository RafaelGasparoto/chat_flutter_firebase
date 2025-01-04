import 'package:flutter/material.dart';

class LabelDivider extends StatelessWidget {
  const LabelDivider(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}