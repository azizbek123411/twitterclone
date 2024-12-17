import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclone/service/database/database_provider.dart';
import 'package:twitterclone/ui/pages/drawer_screens/profile.dart';
import 'package:twitterclone/ui/widgets/followers_tile.dart';
import 'package:twitterclone/utility/app_padding.dart';
import 'package:twitterclone/utility/screen_utils.dart';

import '../../../models/user.dart';

class FollowingListPage extends StatefulWidget {
  final String uid;

  const FollowingListPage({super.key, required this.uid});

  @override
  State<FollowingListPage> createState() => _FollowingListPageState();
}

class _FollowingListPageState extends State<FollowingListPage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    loadFollowersList();
    loadFollowingList();
  }

  Future<void> loadFollowersList() async {
    await databaseProvider.loadUserFollowerProfiles(widget.uid);
  }

  Future<void> loadFollowingList() async {
    await databaseProvider.loadUserFollowingProfiles(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final followers = listeningProvider.getListOfFollowersProfile(widget.uid);
    final following = listeningProvider.getListOfFollowingProfiles(widget.uid);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottom: TabBar(
              dividerHeight: 0,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
              tabs: const [
                Tab(
                  text: 'Following',
                ),
                Tab(
                  text: 'Followers',
                )
              ]),
        ),
        body: Padding(
          padding: Dis.only(top: 10.h),
          child: TabBarView(
            children: [
              buildUserList(following, "No following"),
              buildUserList(followers, "No followers"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserList(List<UserProfile> userList, String emptyMessage) {
    return userList.isEmpty
        ? Center(
            child: Text(
              emptyMessage,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          )
        : ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return FollowersTile(
                name: user.name,
                uid: user.uid,
              );
            });
  }
}
