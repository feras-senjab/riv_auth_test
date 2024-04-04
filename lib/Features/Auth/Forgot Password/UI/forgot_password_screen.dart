import 'package:flutter/material.dart';
import 'package:riv_auth_test/Components/entry_field.dart';
import 'package:riv_auth_test/Components/my_button.dart';
import 'package:riv_auth_test/Global/Style/colors.dart';
import 'package:riv_auth_test/Helpers/dialog_helper.dart';
import 'package:riv_auth_test/Helpers/loading_helper.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validators/form_validators.dart';

import '../Controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //--------- Listen to state changes -----------//
    ref.listen<ForgotPasswordState>(
      forgotPasswordProvider,
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
              DialogHelper.showCustomAlert(
                context: context,
                title: 'Reset Link Sent',
                content: 'Please check your email to reset password.',
                dismissible: false,
                popDialogOnBtn1Pressed: true,
                onBtnPressed: () {
                  Navigator.of(context).pop();
                },
              );
            }
          }
        }
      },
    );
    //------------ Controller & State --------------//
    final forgotPasswordController = ref.read(forgotPasswordProvider.notifier);
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
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
              'Enter your email to send reset link..',
              style: TextStyle(
                color: kMainColor,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
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
              onChanged: (email) =>
                  forgotPasswordController.emailChanged(email),
              errorText: forgotPasswordState.email.invalid
                  ? Email.showEmailErrorMessage(forgotPasswordState.email.error)
                  : null,
            ),
            SizedBox(
              height: 3.h,
            ),
            Center(
              child: MyButton(
                width: 50.w,
                text: 'Send Reset Link',
                onPressed: () {
                  //! Navigation is done by status listener..
                  forgotPasswordState.status.isValidated
                      ? forgotPasswordController.forgotPassword()
                      : DialogHelper.showCustomAlert(
                          context: context,
                          title: 'Email not set',
                          content:
                              'Please make sure to set the email correctly.',
                        );
                },
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '<< Back to sign in',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
