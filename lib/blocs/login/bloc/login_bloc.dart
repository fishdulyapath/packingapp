import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobilepacking/blocs/login/form_submission_status.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc({required this.authRepo}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // Username updated
    if (event is LoginUsernameChanged) {
      yield state.copyWith(
          username: event.username, formStatus: InitialFormStatus());

      // Password updated
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(
          password: event.password, formStatus: InitialFormStatus());

      // Form submitted
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        // await authRepo.login();
        // yield state.copyWith(formStatus: SubmissionSuccess());
        final accessToken =
            await authRepo.signin(state.username, state.password);
        // try get user
        final user = await authRepo.getUser(accessToken);
        // authenticationBloc.add(AuthenticationStatusChanged(status: AuthenticationStatus.authenticated, token: accessToken));

        yield state.copyWith(
            formStatus: SubmissionSuccess(token: accessToken, user: user));
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e.toString()));
      }
    }
  }
}
