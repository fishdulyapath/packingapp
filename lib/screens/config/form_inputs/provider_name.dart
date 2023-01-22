import 'package:formz/formz.dart';

enum ProviderNameValidationError { invalid }

class ProviderName extends FormzInput<String, ProviderNameValidationError> {
  const ProviderName.pure() : super.pure('');
  const ProviderName.dirty([String value = '']) : super.dirty(value);

  static final RegExp _providerNameRegExp = RegExp(
    r'^.{6,}$',
  );

  @override
  ProviderNameValidationError? validator(String value) {
    return _providerNameRegExp.hasMatch(value.trim())
        ? null
        : ProviderNameValidationError.invalid;
  }
}
