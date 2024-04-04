import 'package:equatable/equatable.dart';
import 'package:form_validators/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riv_auth_test/Providers/auth_rep_provider.dart';
import 'package:authentication_repository/authentication_repository.dart';

part "signup_state.dart";

final signUpProvider =
    StateNotifierProvider.autoDispose<SignUpController, SignUpState>(
  (ref) => SignUpController(ref.watch(authRepoProvider)),
);

class SignUpController extends StateNotifier<SignUpState> {
  final AuthenticationRepository _authenticationRepository;
  SignUpController(this._authenticationRepository) : super(const SignUpState());

  void nameChanged(String value) {
    final name = Name.dirty(value);

    state = state.copyWith(
      name: name,
      status: Formz.validate(
        [
          name,
          state.email,
          state.password,
          state.confirmedPassword,
        ],
      ),
    );
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);

    state = state.copyWith(
      email: email,
      status: Formz.validate(
        [
          state.name,
          email,
          state.password,
          state.confirmedPassword,
        ],
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);

    state = state.copyWith(
      password: password,
      status: Formz.validate(
        [
          state.name,
          state.email,
          password,
          state.confirmedPassword,
        ],
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
        password: state.password.value, confirmedPassword: value);
    state = state.copyWith(
      confirmedPassword: confirmedPassword,
      status: Formz.validate(
        [
          state.name,
          state.email,
          state.password,
          confirmedPassword,
        ],
      ),
    );
  }

  void signUpWithEmailAndPassword() async {
    if (!state.status.isValidated) return;
    state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      await _authenticationRepository.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );

      state = state.copyWith(status: FormzStatus.submissionSuccess);
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.code);
    }
  }
}
