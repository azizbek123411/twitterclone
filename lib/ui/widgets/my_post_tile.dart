import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclone/models/post.dart';
import 'package:twitterclone/service/auth/auth_service.dart';
import 'package:twitterclone/service/database/database_provider.dart';
import 'package:twitterclone/ui/widgets/input_alert_box.dart';
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
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

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
                    onTap: () async {
                      Navigator.pop(context);
                      await databaseProvider.deletePost(widget.post.id);
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
                  ListTile(
                    leading: const Icon(
                      Icons.flag,
                    ),
                    title: const Text(
                      'Report',
                      style: TextStyle(),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      _reportPostConfirmationBox();
                    },
                  ),
                  //  ListTile(
                  //   onTap: (){
                  //     Navigator.pop(context);
                  //     _blockUserConfirmationBox();
                  //   },
                  //   leading: const Icon(
                  //     Icons.block,
                  //   ),
                  //   title: const Text(
                  //     'Block User',
                  //     style: TextStyle(),
                  //   ),
                  // ),
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

  void _reportPostConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Report Message'),
            content: const Text('Are you sure you want to report this message?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await databaseProvider.reportUser(
                    widget.post.id,
                    widget.post.uid,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message reported'),
                      
                    ),
                  );
                },
                child: const Text('Report'),
              ),
            ],
          );
        });
  }

  void _blockUserConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Block User'),
            content: const Text('Are you sure you want to block this user?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await databaseProvider.blockUsers(widget.post.uid);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User blocked'),

                    ),
                  );
                },
                child: const Text('Block'),
              ),
            ],
          );
        });
  }
  void _openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textEditingController: commentController,
        hintText: 'Comment',
        onPressed: () async {
          await addComment();
        },
        onPressedText: 'Post',
      ),
    );
  }

  Future<void> addComment() async {
    if (commentController.text.trim().isEmpty) return;

    try {
      await databaseProvider.addComment(
          widget.post.id, commentController.text.trim());
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadComments() async {
    await databaseProvider.loadComments(widget.post.id);
  }

  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool likedByCurrentUser = listeningProvider.isPostLikedByCurrentUser(
      widget.post.id,
    );
    int likeCount = listeningProvider.getLikeCount(widget.post.id);
    int commentLength = listeningProvider.getComments(widget.post.id).length;

    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        margin: Dis.all(10),
        padding: Dis.only(
          // tb: 12.h,
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
            ),

            // SizedBox(height: 10.h,),
            Row(
              children: [
                IconButton(
                  onPressed: _toggleLikePost,
                  icon: !likedByCurrentUser
                      ? Icon(
                          Icons.favorite_border,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                ),
                Text(
                  likeCount == 0 ? '' : likeCount.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: _openNewCommentBox,
                  icon: Icon(
                    Icons.comment_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  commentLength != 0 ? commentLength.toString() : '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
