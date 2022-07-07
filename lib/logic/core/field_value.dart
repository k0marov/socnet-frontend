import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/error/form_failures.dart';

class FieldValue extends Equatable {
  final String value;
  final FormFailure? failure;
  @override
  List get props => [value, failure];
  const FieldValue([this.value = "", this.failure]);

  FieldValue withValue(String newValue) => FieldValue(newValue, failure);
  FieldValue withFailure(FormFailure newFailure) => FieldValue(value, newFailure);
  FieldValue withoutFailure() => FieldValue(value);
}
