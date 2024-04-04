import 'package:equatable/equatable.dart';
import 'package:form_validators/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riv_auth_test/Providers/auth_rep_provider.dart';
import 'package:authentication_repository/authentication_repository.dart';

part 'signin_state.dart';

final signInProvider =
    StateNotifierProvider.autoDispose<SignInController, SignInState>(
  (ref) => SignInController(ref.watch(authRepoProvider)),
);

class SignInController extends StateNotifier<SignInState> {
  final AuthenticationRepository _authenticationRepository;
  SignInController(this._authenticationRepository) : super(const SignInState());

  void emailChanged(String value) {
    final email = Email.dirty(value);

    state = state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);

    state = state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    );
  }

  void signInWithEmailAndPassword() async {
    if (!state.status.isValidated) return;
    state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      await _authenticationRepository.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );

      state = state.copyWith(status: FormzStatus.submissionSuccess);
    } on SignInWithEmailAndPasswordFailure catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.code);
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: FormzStatus.submissionInProgress);

    try {
      final isNewUser = await _authenticationRepository.signInWithGoogle();

      if (isNewUser != null && isNewUser) {
        // write to database
        // call cloud firestore repository
      }

      state = state.copyWith(status: FormzStatus.submissionSuccess);
    } on SignInWithGoogleFailure catch (_) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Google sign in failed.');
    }
  }
}
