import 'package:formz/formz.dart';

enum ServiceUrlValidationError { invalid }

class ServiceUrl extends FormzInput<String, ServiceUrlValidationError> {
  const ServiceUrl.pure() : super.pure('');
  const ServiceUrl.dirty([String value = '']) : super.dirty(value);

  static final RegExp _serviceUrlRegExp = RegExp(
    r'^.{6,}$',
  );

  @override
  ServiceUrlValidationError? validator(String value) {
    return _serviceUrlRegExp.hasMatch(value.trim())
        ? null
        : ServiceUrlValidationError.invalid;
  }
}
