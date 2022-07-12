import 'package:dartz/dartz.dart';

import 'exceptions.dart';
import 'failures.dart';

Future<Either<Failure, T>> exceptionToFailureCall<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } on NoTokenException {
    return Left(NoTokenFailure());
  } on CacheException {
    return Left(CacheFailure());
  } on MappingException {
    return Left(MappingFailure());
  } catch (e) {
    final failure = e is NetworkException ? NetworkFailure(e) : NetworkFailure.unknown;
    return Left(failure);
  }
}
