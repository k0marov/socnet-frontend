import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/core/debug.dart';
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
    return _loginOrRegister(username, password, loginEndpoint());
  }

  @override
  Future<TokenModel> register(String username, String password) async {
    return _loginOrRegister(username, password, registerEndpoint());
  }

  Future<TokenModel> _loginOrRegister(String username, String password, EndpointQuery eq) async {
    return exceptionConverterCall(() async {
      final url = eq.toURL(_apiHost, useHTTPS);
      final requestBody = {
        'username': username,
        'password': password,
      };
      printDebug("POST $url: $requestBody");
      final apiResponse = await _httpClient.post(url,
          headers: {
            'Accept': 'application/json',
          },
          body: json.encode(requestBody));
      printResponse(apiResponse);
      checkStatusCode(apiResponse);
      final jsonResponse = json.decode(apiResponse.body);
      return TokenModel.fromJson(jsonResponse);
    });
  }
}
