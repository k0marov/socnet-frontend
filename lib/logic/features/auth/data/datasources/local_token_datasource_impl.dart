import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:socnet/logic/core/error/failures.dart';

import '../../domain/datasources/local_token_datasource.dart';

class LocalTokenDataSourceImpl implements LocalTokenDataSource {
  static const _tokenCacheKey = "AUTH_TOKEN";
  final RxSharedPreferences _sharedPrefs;

  LocalTokenDataSourceImpl(this._sharedPrefs);

  @override
  Future<void> storeToken(String token) async {
    try {
      await _sharedPrefs.setString(_tokenCacheKey, token);
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _sharedPrefs.remove(_tokenCacheKey);
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Stream<Either<CacheFailure, String?>> getTokenStream() {
    return _sharedPrefs.getStringStream(_tokenCacheKey).transform(
          StreamTransformer.fromHandlers(
            handleData: (token, sink) => sink.add(Right(token)),
            handleError: (error, _, sink) => sink.add(Left(CacheFailure())),
          ),
        );
  }

  @override
  Future<String?> getToken() {
    return _sharedPrefs.getString(_tokenCacheKey);
  }
}
