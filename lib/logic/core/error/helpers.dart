import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:socnet/logic/core/error/failures.dart';

/// should be used in NetworkDatasources
void checkStatusCode(http.Response response) {
  if (response.statusCode != 200) {
    throw NetworkFailure.fromApiResponse(
      response.statusCode,
      response.body,
    );
  }
}

/// should be used in repositories
Future<Either<Failure, T>> failureToLeft<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } catch (e) {
    print("Caught exception: $e");
    return Left(e is Failure ? e : UnknownFailure(e));
  }
}
