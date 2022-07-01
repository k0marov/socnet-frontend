import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';

abstract class UseCase<ReturnType, Params> {
  const UseCase();
  Future<Either<Failure, ReturnType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List get props => [];
}
