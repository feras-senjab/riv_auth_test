part of 'auth_controller.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser user;

  const AuthState._({
    required this.status,
    this.user = AuthUser.empty,
  });

  const AuthState.authenticated(AuthUser user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}
