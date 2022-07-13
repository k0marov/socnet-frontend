import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class LocalTokenDataSource {
  /// Stores the token in the cache, replacing the previous one if it existed
  /// Throws [CacheFailure] if there was some error
  Future<void> storeToken(String token);

  /// Deletes the currently stored token in the local cache
  /// Throws [CacheFailure] if there was some error
  Future<void> deleteToken();

  /// A stream of tokens that are stored in the local cache
  Stream<Either<CacheFailure, String?>> getTokenStream();
}
