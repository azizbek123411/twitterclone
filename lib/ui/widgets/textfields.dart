import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  bool? obscure;

   TextFields({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
obscureText: obscure??false,
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary
        ),
        hintText: hintText,
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
