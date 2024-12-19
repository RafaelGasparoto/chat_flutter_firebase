import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({required this.controller, required this.labelText, this.padding, super.key});

  final String labelText;
  final TextEditingController controller;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
