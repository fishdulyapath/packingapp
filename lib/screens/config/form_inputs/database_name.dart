import 'package:formz/formz.dart';

enum DatabaseNameValidationError { invalid }

class DatabaseName extends FormzInput<String, DatabaseNameValidationError> {
  const DatabaseName.pure() : super.pure('');
  const DatabaseName.dirty([String value = '']) : super.dirty(value);

  static final RegExp _databaseNameRegExp = RegExp(
    r'^.{6,}$',
  );

  @override
  DatabaseNameValidationError? validator(String value) {
    return _databaseNameRegExp.hasMatch(value.trim())
        ? null
        : DatabaseNameValidationError.invalid;
  }
}
