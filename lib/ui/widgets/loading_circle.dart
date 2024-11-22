import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
        content: Center(
          child: CircularProgressIndicator(),
        ),
    ),
  );
}

void hideLoading(BuildContext context){
  Navigator.pop(context);
}
