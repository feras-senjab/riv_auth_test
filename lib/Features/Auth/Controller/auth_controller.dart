import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:riv_auth_test/Providers/auth_rep_provider.dart';

part 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.watch(authRepoProvider)),
);

class AuthController extends StateNotifier<AuthState> {
  final AuthenticationRepository _authRepository;
  late final StreamSubscription _streamSubscription;

  AuthController(this._authRepository)
      : super(const AuthState.unauthenticated()) {
    _streamSubscription =
        _authRepository.user.listen((user) => _onUserChanged(user));
  }

  void _onUserChanged(AuthUser user) {
    if (user.isEmpty) {
      state = const AuthState.unauthenticated();
    } else {
      state = AuthState.authenticated(user);
    }
  }

  void signOut() {
    _authRepository.signOut();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
