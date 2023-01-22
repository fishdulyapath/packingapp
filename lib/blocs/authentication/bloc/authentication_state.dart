part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._(
      {this.status = AuthenticationStatus.unknown, this.token, this.user});

  final AuthenticationStatus status;
  final AuthenticationToken? token;
  final User? user;

  @override
  List<Object?> get props => [status, token, user];

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(AuthenticationToken token, User? user)
      : this._(
            status: AuthenticationStatus.authenticated,
            token: token,
            user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.reauthenticated(AuthenticationToken token)
      : this._(status: AuthenticationStatus.refreshauthenticated, token: token);
}
