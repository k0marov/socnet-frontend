import '../entities/token_entity.dart';

abstract class NetworkAuthDataSource {
  /// Logins using the api
  /// Returns the auth token
  /// Throws [NetworkFailure] if some error happened
  Future<Token> login(String username, String password);

  /// Registers a new user using the api
  /// Returns the auth token
  /// Throws [NetworkFailure] if some error happened
  Future<Token> register(String username, String password);
}
