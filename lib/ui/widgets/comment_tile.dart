import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclone/models/comment.dart';
import 'package:twitterclone/service/database/database_provider.dart';
import 'package:twitterclone/utility/screen_utils.dart';

import '../../service/auth/auth_service.dart';
import '../../utility/app_padding.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final void Function() onUserTap;

  const CommentTile(
      {super.key, required this.comment, required this.onUserTap});

  void _showOptions(BuildContext context) {
    String currentId = AuthService().getCurrentUid();
    final bool isOwnComment = comment.uid == currentId;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                if (isOwnComment)
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      await Provider.of<DatabaseProvider>(context,
                              listen: false)
                          .deleteComment(
                        comment.id,
                        comment.postId,
                      );
                    },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        Padding(
          padding: Dis.only(lr: 20.w),
          child: GestureDetector(
            onTap: onUserTap,
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  comment.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '    @${comment.username}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () =>_showOptions(context),
                  icon: Icon(
                    Icons.more_vert_sharp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ),
        ),
        // SizedBox(height: 10.h,),
        Padding(
          padding: Dis.only(lr: 20.w),
          child: Text(
            comment.message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Divider(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ],
    );
  }
}
