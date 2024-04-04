import 'package:flutter/material.dart';
import 'package:riv_auth_test/Components/my_button.dart';
import 'package:riv_auth_test/Features/Auth/Controller/auth_controller.dart';
import 'package:riv_auth_test/Features/Auth/SignIn/UI/signin_screen.dart';
import 'package:riv_auth_test/Helpers/nav_helper.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authProvider.notifier);
    final authUser = ref.watch(authProvider).user;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Welcome USERNAME\n${authUser.email}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: MyButton(
                text: 'Sign out',
                width: 30.w,
                onPressed: () {
                  authController.signOut();
                  NavHelper.pushAndRemoveUntil(context, const SignInScreen());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
