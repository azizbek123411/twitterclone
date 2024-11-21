import 'package:flutter/material.dart';
import 'package:twitterclone/ui/pages/register_pages/sign_up_page.dart';

import 'login_page.dart';

class SignInUp extends StatefulWidget {
  const SignInUp({super.key});

  @override
  State<SignInUp> createState() => _SignInUpState();
}

class _SignInUpState extends State<SignInUp> {

  bool showLoginPage=true;

  void togglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(
      onTap: (){
        togglePages();
      },
    );
    }else {
      return SignUpPage(
      onTap: togglePages,
    );
    }
  }
}
