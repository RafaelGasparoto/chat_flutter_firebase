import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.padding,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final EdgeInsets? padding;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: LayoutBuilder(
        builder: (context, constraints) => ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all<Size>(
              Size(constraints.maxWidth, 30),
            ),
          ),
          child: FittedBox(child: Text(label)),
        ),
      ),
    );
  }
}
