import 'package:mobilepacking/data/struct/error_message.dart';

class ErrorStack {
  bool isError;
  List<ErrorMessage> errorMessages;

  ErrorStack({this.isError = false, List<ErrorMessage>? errorMessages})
      : this.errorMessages = errorMessages ?? <ErrorMessage>[];

  void add(ErrorMessage errorMessage) {
    this.isError = true;
    this.errorMessages.add(errorMessage);
  }

  void addError(String code, String message) {
    this.isError = true;
    this.errorMessages.add(ErrorMessage(code, message));
  }

  static ErrorStack error(String code, String message) {
    ErrorStack _errorStack = ErrorStack(isError: true);
    _errorStack.errorMessages.add(ErrorMessage(code, message));
    return _errorStack;
  }
}
