import 'package:dartz/dartz.dart';

import 'exceptions.dart';
import 'failures.dart';

Future<Either<Failure, T>> exceptionToFailureCall<T>(
    Future<T> Function() call) async {
  try {
    return Right(await call());
  } on NoTokenException {
    return Left(NoTokenFailure());
  } catch (e) {
    return Left(NetworkFailure.fromException(e as NetworkException));
  }
}
