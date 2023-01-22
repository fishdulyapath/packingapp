import 'package:mobilepacking/repositories/auth_repository.dart';

abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {
  SubmissionSuccess({required this.token, required this.user});
  final AuthenticationToken token;
  final User user;
}

class SubmissionFailed extends FormSubmissionStatus {
  final String exception;

  SubmissionFailed(this.exception);
}
