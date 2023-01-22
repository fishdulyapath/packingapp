import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required this.authenticationProvider})
      : super(AuthenticationState.unknown());

  final AuthRepository authenticationProvider;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      yield AuthenticationState.unknown();
    }
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
    AuthenticationStatusChanged event,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthenticationState.unauthenticated();
      case AuthenticationStatus.authenticated:
        var token = event.token;
        var user = event.user;

        if (user == null && token != null) {
          // try get user
          try {
            user = await authenticationProvider.getUser(token);
          } catch (ex) {}
        }

        return token != null && user != null
            ? AuthenticationState.authenticated(token, user)
            : const AuthenticationState.unauthenticated();
      default:
        return const AuthenticationState.unknown();
    }
  }

  @override
  AuthenticationState fromJson(Map<String, dynamic> json) {
    var tokenString = json['token'] ?? '';

    if (tokenString != '') {
      var token = AuthenticationToken.fromString(tokenString);
      return AuthenticationState.reauthenticated(token);
    }
    return AuthenticationState.unauthenticated();
  }

  @override
  Map<String, dynamic> toJson(AuthenticationState state) =>
      {'token': state.token?.toJson()};
}
