import 'package:flutter/material.dart';
import 'package:twitterclone/utility/app_padding.dart';
import 'package:twitterclone/utility/screen_utils.dart';

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
    return Column(
      children: [
        Container(
          padding: Dis.only(tb: 15.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
              title: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: action),
        ),
       const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
