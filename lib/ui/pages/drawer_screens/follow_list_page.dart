import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclone/service/database/database_provider.dart';
import 'package:twitterclone/ui/pages/drawer_screens/profile.dart';

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
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(
              text: 'Following',
            ),
            Tab(
              text: 'Followers',
            )
          ]),
        ),
        body: TabBarView(
          children: [
            buildUserList(following, "No following"),
            buildUserList(followers, "No followers"),
          ],
        ),
      ),
    );
  }

  Widget buildUserList(List<UserProfile> userList, String emptyMessage) {
    return userList.isEmpty
        ? Center(
            child: Text(emptyMessage),
          )
        : ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      uid: user.uid,
                    ),
                  ),
                ),
                title: Text(
                  user.name,
                ),
              );
            });
  }
}
