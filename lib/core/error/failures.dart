import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/exceptions.dart';

class Failure extends Equatable {
  @override
  List get props => [];
  const Failure();
}

class NoTokenFailure extends Failure {}

/// statusCode == -1 means "Unknown, probably no internet connection"
class NetworkFailure extends Failure {
  final int statusCode;
  final String? detail;

  @override
  List get props => [statusCode, detail];

  const NetworkFailure(this.statusCode, this.detail);
  const NetworkFailure.unknown() : this(-1, null);
  NetworkFailure.fromException(NetworkException e)
      : this(
          e.statusCode,
          e.detail,
        );
}

class CacheFailure extends Failure {}
