import 'package:equatable/equatable.dart';

class FormFailure extends Equatable {
  final String code;
  @override
  List get props => [code];
  const FormFailure._(this.code);
}

const invalidCredentials = FormFailure._("invalid-credentials");
const usernameTaken = FormFailure._("username-taken");
const usernameInvalid = FormFailure._("username-invalid");
const passwordsDontMatch = FormFailure._("posswords-dont-match");
const emptyText = FormFailure._("empty-text");
const textTooLong = FormFailure._("long-text");
