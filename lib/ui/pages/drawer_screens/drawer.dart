import 'package:flutter/material.dart';
import 'package:twitterclone/service/auth/auth_service.dart';
import 'package:twitterclone/ui/pages/drawer_screens/profile.dart';
import 'package:twitterclone/ui/pages/drawer_screens/settings.dart';
import 'package:twitterclone/ui/widgets/drawer_tile.dart';
import 'package:twitterclone/utility/screen_utils.dart';

import '../../../utility/app_padding.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final _auth = AuthService();

  void logout() {
    _auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: Dis.only(lr: 50.w, top: 30.h),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
                size: 72,
              ),
            ),
            Divider(
              indent: 25,
              endIndent: 25,
              color: Theme.of(context).colorScheme.secondary,
            ),
            DrawerTile(
              onTap: () {
                Navigator.pop(context);
              },
              text: 'Home',
              icon: Icons.home_filled,
            ),
            DrawerTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      uid: _auth.getCurrentUid(),
                    ),
                  ),
                );
              },
              text: 'Profile',
              icon: Icons.person,
            ),
            DrawerTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
              text: 'Settings',
              icon: Icons.settings,
            ),
            DrawerTile(
              onTap: () {},
              text: 'Search',
              icon: Icons.search_sharp,
            ),
            const Spacer(),
            DrawerTile(
              onTap: logout,
              text: 'Log Out',
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}
