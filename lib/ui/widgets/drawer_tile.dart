import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onTap;

  const DrawerTile({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text.toUpperCase(),
        style: TextStyle(
          letterSpacing: 2,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: 30,
      ),
      onTap: onTap,
    );
  }
}
