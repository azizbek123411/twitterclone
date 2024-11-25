import 'package:flutter/material.dart';
import 'package:twitterclone/models/post.dart';
import 'package:twitterclone/utility/app_padding.dart';
import 'package:twitterclone/utility/screen_utils.dart';

class MyPostTile extends StatefulWidget {
  final Post post;

  const MyPostTile({
    super.key,
    required this.post,
  });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Dis.all(10),
      padding: Dis.only(
        tb: 18.h,
        lr: 12.w,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                widget.post.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                ),
              ),
              Text(
                '    @${widget.post.username}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h,),
          Text(
            widget.post.message,
            style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 18,),
          )
        ],
      ),
    );
  }
}
