import 'package:flutter/material.dart';
import 'package:twitterclone/models/post.dart';
import 'package:twitterclone/service/auth/auth_service.dart';
import 'package:twitterclone/utility/app_padding.dart';
import 'package:twitterclone/utility/screen_utils.dart';

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const MyPostTile(
      {super.key,
      required this.post,
      required this.onUserTap,
      required this.onPostTap});

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  void _showOptions() {
    String currentId = AuthService().getCurrentUid();
    final bool isOwnPost = widget.post.uid == currentId;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                if (isOwnPost)
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.delete,
                    ),
                    title: const Text(
                      'Delete',
                      style: TextStyle(),
                    ),
                  )
                else ...[
                  const ListTile(
                    leading: Icon(
                      Icons.flag,
                    ),
                    title: Text(
                      'Report',
                      style: TextStyle(),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.block,
                    ),
                    title: Text(
                      'Block User',
                      style: TextStyle(),
                    ),
                  ),
                ],
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.cancel,
                  ),
                  title: const Text(
                    'Cancel',
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        margin: Dis.all(10),
        padding: Dis.only(
          tb: 12.h,
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
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
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
                  const Spacer(),
                  IconButton(
                    onPressed: _showOptions,
                    icon: Icon(
                      Icons.more_vert_sharp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),
            // SizedBox(height: 10.h,),
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
