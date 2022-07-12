import 'package:dartz/dartz.dart';

import 'error/failures.dart';

typedef UseCaseReturn<T> = Future<Either<Failure, T>>;
