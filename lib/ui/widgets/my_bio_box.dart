import 'package:flutter/material.dart';
import 'package:twitterclone/utility/app_padding.dart';

class MyBioBox extends StatelessWidget {
  String text;

  MyBioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: Dis.all(25),

      child: Text(
        text.isNotEmpty ? text : "Empty bio",
        style:  TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
