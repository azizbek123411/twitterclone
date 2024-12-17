import 'package:flutter/material.dart';
import 'package:twitterclone/ui/pages/drawer_screens/profile.dart';

class FollowersTile extends StatelessWidget {
  final String name;
final String uid;
  const FollowersTile({super.key, required this.name,required this.uid});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(uid: uid),),);
          },
          leading: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}
