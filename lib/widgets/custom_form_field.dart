import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    required this.labelText,
    required this.onSaved,
    this.padding,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    super.key,
  });

  final String labelText;
  final EdgeInsets? padding;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
        validator: validator,
        obscureText: obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSaved: onSaved,
      ),
    );
  }
}
