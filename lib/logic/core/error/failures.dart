import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/error/exceptions.dart';

class Failure extends Equatable {
  @override
  List get props => [];
  const Failure();
}

class NoTokenFailure extends Failure {}

/// statusCode == -1 means "Unknown, probably no internet connection"
class NetworkFailure extends Failure {
  final NetworkException exception;

  @override
  List get props => [exception];

  const NetworkFailure(this.exception);
  static const unknown = NetworkFailure(NetworkException(-1, null));
}

class CacheFailure extends Failure {}

class HashingFailure extends Failure {}

class WeakPassFailure extends Failure {}
