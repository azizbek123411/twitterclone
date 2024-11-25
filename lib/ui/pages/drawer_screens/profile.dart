import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclone/models/user.dart';
import 'package:twitterclone/service/auth/auth_service.dart';
import 'package:twitterclone/service/database/database_provider.dart';
import 'package:twitterclone/ui/widgets/input_alert_box.dart';
import 'package:twitterclone/ui/widgets/my_bio_box.dart';
import 'package:twitterclone/ui/widgets/my_post_tile.dart';
import 'package:twitterclone/utility/app_padding.dart';
import 'package:twitterclone/utility/screen_utils.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bioTextController = TextEditingController();
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(
      widget.uid,
    );
    setState(() {
      isLoading = false;
    });
  }

  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textEditingController: bioTextController,
        hintText: 'Edit bio',
        onPressed: saveBio,
        onPressedText: 'Save',
      ),
    );
  }

  Future<void> saveBio() async {
    setState(() {
      isLoading = true;
    });

    await databaseProvider.updateBio(
      bioTextController.text,
    );
    await loadUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allUserPosts = listeningProvider.filterUserPosts(
      widget.uid,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          isLoading ? "..." : user!.name,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              isLoading ? "..." : "@${user!.username}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: Dis.all(25),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: Dis.only(lr: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bio',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: _showEditBioBox,
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ),
          MyBioBox(
            text: isLoading ? '...' : user!.bio,
          ),
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: Dis.only(lr: 20.w,),
            child: Text(
              'Your Posts',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          allUserPosts.isEmpty
              ? const Center(
                  child: Text(
                    'No posts yet..',
                  ),
                )
              : Padding(
                padding: Dis.only(lr: 10.w,),
                child: ListView.builder(
                    itemCount: allUserPosts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final post = allUserPosts[index];
                      return MyPostTile(post: post);
                    },
                  ),
              ),
        ],
      ),
    );
  }
}
