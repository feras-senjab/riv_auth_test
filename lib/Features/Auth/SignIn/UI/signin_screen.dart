import 'package:flutter/material.dart';
import 'package:riv_auth_test/Components/my_button.dart';
import 'package:riv_auth_test/Features/Auth/Forgot%20Password/UI/forgot_password_screen.dart';
import 'package:riv_auth_test/Features/Auth/SignUp/UI/signup_screen.dart';
import 'package:riv_auth_test/Features/Home/UI/home_screen.dart';
import 'package:riv_auth_test/Global/Style/colors.dart';
import 'package:riv_auth_test/Helpers/dialog_helper.dart';
import 'package:riv_auth_test/Helpers/loading_helper.dart';
import 'package:riv_auth_test/Helpers/nav_helper.dart';
import 'package:sizer/sizer.dart';
import 'package:riv_auth_test/Components/entry_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validators/form_validators.dart';

import '../Controller/signin_controller.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //--------- Listen to state changes -----------//
    ref.listen<SignInState>(
      signInProvider,
      (previous, current) {
        if (current.status.isSubmissionInProgress) {
          LoadingHelper.showLoading();
        } else {
          LoadingHelper.dismissLoading();
          if (current.status.isSubmissionFailure) {
            DialogHelper.showCustomAlert(
              context: context,
              title: 'Error',
              content: '${current.errorMessage}',
            );
          } else {
            if (current.status.isSubmissionSuccess) {
              NavHelper.pushAndRemoveUntil(context, const HomeScreen());
            }
          }
        }
      },
    );
    //------------ Controller & State --------------//
    final signInController = ref.read(signInProvider.notifier);
    final signInState = ref.watch(signInProvider);
    //-------------- Style Values -----------------//
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(3.sp),
      ),
      borderSide: const BorderSide(
        color: Color(0xFFE5E5E5),
        width: 1,
      ),
    );

    final focusedBorder = inputBorder.copyWith(
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 255, 221, 0),
        width: 1,
      ),
    );
    //---------------- Scaffold --------------------//
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
          ),
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              'WELCOME TO APP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kMainColor,
                fontWeight: FontWeight.bold,
                fontSize: 19.sp,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            EntryField(
              label: 'Email',
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              inputBorder: inputBorder,
              focusedBorder: focusedBorder,
              onChanged: (email) => signInController.emailChanged(email),
              errorText: signInState.email.invalid
                  ? Email.showEmailErrorMessage(signInState.email.error)
                  : null,
            ),
            EntryField(
              label: 'Password',
              maxLines: 1,
              keyboardType: TextInputType.text,
              obscureText: true,
              inputBorder: inputBorder,
              focusedBorder: focusedBorder,
              onChanged: (password) =>
                  signInController.passwordChanged(password),
              errorText: signInState.password.invalid
                  ? Password.showPasswordErrorMessage(
                      signInState.password.error)
                  : null,
            ),
            Row(
              children: [
                const Text('Forgot your password? '),
                InkWell(
                  onTap: () {
                    NavHelper.push(context, const ForgotPasswordScreen());
                  },
                  child: const Text(
                    'Click here',
                    style: TextStyle(
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                const Text('Don\'t have an account? '),
                InkWell(
                  onTap: () {
                    NavHelper.push(context, const SignUpScreen());
                  },
                  child: const Text(
                    'Register Now!',
                    style: TextStyle(
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            Center(
              child: MyButton(
                width: 50.w,
                text: 'Sign in',
                onPressed: () {
                  //! Navigation is done by status listener..
                  signInState.status.isValidated
                      ? signInController.signInWithEmailAndPassword()
                      : DialogHelper.showCustomAlert(
                          context: context,
                          title: 'Form not completed!',
                          content:
                              'Please make sure to fill the form fields correctly.',
                        );
                },
              ),
            ),
            Center(
              child: MyButton(
                width: 50.w,
                text: 'Google sign in',
                onPressed: () {
                  //! Navigation is done by status listener..
                  signInController.signInWithGoogle();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
