import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String text;
  final Widget action;

  const SettingsTile({
    super.key,
    required this.text,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return      ListTile(
      title: Text(text,style: const TextStyle(fontSize: 20),),
      trailing: action
    );
  }
}
