import 'dart:convert';

import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/features/auth/data/models/token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalTokenDataSource {
  /// Stores the token in the cache, replacing the previous one if it existed
  /// Throws [CacheException] if there was some error
  Future<void> storeToken(TokenModel token);

  /// Returns the currently stored token in the local cache
  /// Throws [NoTokenException] if there is no token in the cache (user is not logged in)
  /// Throws [CacheException] if there was some other error
  Future<TokenModel> getToken();

  /// Deletes the currently stored token in the local cache
  /// Throws [CacheException] if there was some error
  Future<void> deleteToken();
}

const tokenCacheKey = "AUTH_TOKEN";

class LocalTokenDataSourceImpl implements LocalTokenDataSource {
  final SharedPreferences _sharedPreferences;

  LocalTokenDataSourceImpl(this._sharedPreferences);

  @override
  Future<TokenModel> getToken() async {
    try {
      final storedJsonStr = _sharedPreferences.getString(tokenCacheKey);
      if (storedJsonStr == null) throw NoTokenException();
      final jsonToken = json.decode(storedJsonStr);
      return TokenModel.fromJson(jsonToken);
    } catch (e) {
      if (e is NoTokenException) rethrow;
      throw CacheException();
    }
  }

  @override
  Future<void> storeToken(TokenModel token) async {
    try {
      final jsonStr = json.encode(token.toJson());
      final cacheSuccessful =
          await _sharedPreferences.setString(tokenCacheKey, jsonStr);
      if (!cacheSuccessful) throw CacheException();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      final isSuccessful = await _sharedPreferences.remove(tokenCacheKey);
      if (!isSuccessful) throw CacheException();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException();
    }
  }
}
