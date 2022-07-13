import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/core/debug.dart';
import 'package:socnet/logic/core/error/helpers.dart';
import 'package:socnet/logic/features/auth/data/mappers/token_mapper.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

import '../../domain/datasources/network_auth_datasource.dart';

class NetworkAuthDataSourceImpl implements NetworkAuthDataSource {
  final TokenMapper _mapper;
  final http.Client _httpClient;
  final String _apiHost;
  final bool useHTTPS;

  /// useHTTPS should be set to false only in tests
  NetworkAuthDataSourceImpl(this._mapper, this._httpClient, this._apiHost, {this.useHTTPS = true});

  @override
  Future<Token> login(String username, String password) async {
    return _loginOrRegister(username, password, loginEndpoint());
  }

  @override
  Future<Token> register(String username, String password) async {
    return _loginOrRegister(username, password, registerEndpoint());
  }

  Future<Token> _loginOrRegister(String username, String password, EndpointQuery eq) async {
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
    return _mapper.fromJson(jsonResponse);
  }
}
