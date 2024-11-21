import 'package:flutter/material.dart';
import 'package:twitterclone/ui/pages/drawer_screens/settings.dart';
import 'package:twitterclone/ui/widgets/drawer_tile.dart';
import 'package:twitterclone/utils/app_padding.dart';
import 'package:twitterclone/utils/screen_utils.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
              onTap: () {},
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
            DrawerTile(
              onTap: () {},
              text: 'Log Out',
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}
