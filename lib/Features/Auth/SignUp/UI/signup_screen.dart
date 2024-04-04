import 'package:flutter/material.dart';
import 'package:riv_auth_test/Components/entry_field.dart';
import 'package:riv_auth_test/Components/my_button.dart';
import 'package:riv_auth_test/Features/Home/UI/home_screen.dart';
import 'package:riv_auth_test/Global/Style/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validators/form_validators.dart';
import 'package:riv_auth_test/Helpers/dialog_helper.dart';
import 'package:riv_auth_test/Helpers/loading_helper.dart';
import 'package:riv_auth_test/Helpers/nav_helper.dart';
import 'package:sizer/sizer.dart';

import '../Controller/signup_controller.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //--------- Listen to state changes -----------//
    ref.listen<SignUpState>(
      signUpProvider,
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
    final signUpController = ref.read(signUpProvider.notifier);
    final signUpState = ref.watch(signUpProvider);
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
              'Sign up..',
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
              label: 'Name',
              maxLines: 1,
              keyboardType: TextInputType.name,
              inputBorder: inputBorder,
              focusedBorder: focusedBorder,
              onChanged: (name) => signUpController.nameChanged(name),
              errorText: signUpState.name.invalid
                  ? Name.showNameErrorMessage(signUpState.name.error)
                  : null,
            ),
            EntryField(
              label: 'Email',
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              inputBorder: inputBorder,
              focusedBorder: focusedBorder,
              onChanged: (email) => signUpController.emailChanged(email),
              errorText: signUpState.email.invalid
                  ? Email.showEmailErrorMessage(signUpState.email.error)
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
                  signUpController.passwordChanged(password),
              errorText: signUpState.password.invalid
                  ? Password.showPasswordErrorMessage(
                      signUpState.password.error)
                  : null,
            ),
            EntryField(
              label: 'Confirm Password',
              readOnly: !signUpState.password.valid,
              maxLines: 1,
              keyboardType: TextInputType.text,
              obscureText: true,
              inputBorder: inputBorder,
              focusedBorder: focusedBorder,
              onChanged: (confirmedPassword) =>
                  signUpController.confirmedPasswordChanged(confirmedPassword),
              errorText: signUpState.confirmedPassword.invalid
                  ? ConfirmedPassword.showConfirmedPasswordErrorMessage(
                      signUpState.confirmedPassword.error,
                    )
                  : null,
            ),
            SizedBox(
              height: 3.h,
            ),
            Center(
              child: MyButton(
                width: 50.w,
                text: 'Sign up',
                onPressed: () {
                  //! Navigation is done by status listener..
                  signUpState.status.isValidated
                      ? signUpController.signUpWithEmailAndPassword()
                      : DialogHelper.showCustomAlert(
                          context: context,
                          title: 'Form not completed!',
                          content:
                              'Please make sure to fill the form fields correctly.',
                        );
                },
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? '),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
