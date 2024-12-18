import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.padding,
    required this.label,
  });

  final String label;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: LayoutBuilder(
        builder: (context, constraints) => ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all<Size>(
              Size(constraints.maxWidth, 30),
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
