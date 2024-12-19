import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, 
    required this.label,
    required this.padding,
  });

  final String label;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
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
