import 'package:flutter/material.dart';
import 'package:twitterclone/utils/screen_utils.dart';

import '../../../utils/app_padding.dart';
import '../../widgets/buttons.dart';
import '../../widgets/textfields.dart';

class SignUpPage extends StatefulWidget {
  void Function() onTap;

   SignUpPage({super.key,required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: Dis.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.secondary,
                size: 60,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Create account",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              TextFields(
                hintText: 'Enter your email',
                controller: emailController,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFields(
                hintText: 'Enter your password',
                controller: passwordController,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFields(
                hintText: 'Confirm your password',
                controller: confirmPasswordController,
              ),
              SizedBox(
                height: 30.h,
              ),
              Buttons(
                color: Theme.of(context).colorScheme.secondary,
                h: 50.h,
                w: 200.w,
                title: 'Sign Up',
                r: 20,
                onTap: () {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const Text(
                    'Already a member',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onTap,
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
