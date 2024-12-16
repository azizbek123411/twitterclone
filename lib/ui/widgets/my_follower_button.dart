import 'package:flutter/material.dart';

import '../../utility/app_padding.dart';

class MyFollowerButton extends StatelessWidget {
  final void Function()? onTap;
  final bool isFollowing;

  const MyFollowerButton({
    super.key,
    required this.onTap,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dis.all(25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: MaterialButton(
          padding: Dis.all(25),
          color: isFollowing?Theme.of(context).colorScheme.primary:Colors.blue,
          onPressed: onTap,
          child: Text(
            isFollowing?"Unfollow":'Follow',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
