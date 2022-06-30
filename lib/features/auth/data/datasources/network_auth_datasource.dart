import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:socnet/core/const/endpoints.dart' as endpoints;
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/error/helpers.dart';
import 'package:socnet/features/auth/data/models/token_model.dart';

abstract class NetworkAuthDataSource {
  /// Logins using the api
  /// Returns the auth token
  /// Throws [NetworkException] if some error happened
  Future<TokenModel> login(String username, String password);

  /// Registers a new user using the api
  /// Returns the auth token
  /// Throws [NetworkException] if some error happened
  Future<TokenModel> register(String username, String password);
}

class NetworkAuthDataSourceImpl implements NetworkAuthDataSource {
  final http.Client _httpClient;
  final String _apiHost;
  final bool useHTTPS;

  /// useHTTPS should be set to false only in tests
  NetworkAuthDataSourceImpl(this._httpClient, this._apiHost, {this.useHTTPS = true});

  @override
  Future<TokenModel> login(String username, String password) async {
    return _loginOrRegister(username, password, endpoints.loginEndpoint());
  }

  @override
  Future<TokenModel> register(String username, String password) async {
    return _loginOrRegister(username, password, endpoints.registerEndpoint());
  }

  Future<TokenModel> _loginOrRegister(String username, String password, String endpoint) async {
    return exceptionConverterCall(() async {
      final uri = useHTTPS ? Uri.https(_apiHost, endpoint) : Uri.http(_apiHost, endpoint);
      final requestBody = {
        'username': username,
        'password': password,
      };
      print(uri);
      print(requestBody);
      final apiResponse = await _httpClient.post(uri,
          headers: {
            'Accept': 'application/json',
          },
          body: json.encode(requestBody));
      if (apiResponse.statusCode != 200) {
        throw NetworkException.fromApiResponse(
          apiResponse.statusCode,
          apiResponse.body,
        );
      }
      final jsonResponse = json.decode(apiResponse.body);
      print(jsonResponse);
      return TokenModel.fromJson(jsonResponse);
    });
  }
}
