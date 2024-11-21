import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const TextFields({
    super.key,
    required this.hintText,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: Colors.grey.shade700
        ),
        hintText: hintText,
        fillColor: Colors.white30,
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
