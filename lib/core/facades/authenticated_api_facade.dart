import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/simple_file/simple_file.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/features/auth/domain/usecases/get_auth_token_usecase.dart';

class AuthenticatedAPIFacade {
  final http.Client _httpClient;
  final GetAuthTokenUseCase _getToken;
  final String _apiHost;
  final bool useHTTPS;

  /// useHTTPS should be set to false only in tests
  AuthenticatedAPIFacade(this._getToken, this._httpClient, this._apiHost, {this.useHTTPS = true});

  Future<http.Response> get(String endpoint, Map<String, String> body) async {
    final tokenEntity = await _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    return _httpClient.get(_composeURL(endpoint, body), headers: headers);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final tokenEntity = await _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    return _httpClient.post(
      _composeURL(endpoint),
      body: json.encode(body),
      headers: headers,
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final tokenEntity = await _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    return _httpClient.delete(
      _composeURL(endpoint),
      headers: headers,
    );
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final tokenEntity = await _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    return _httpClient.put(
      _composeURL(endpoint),
      body: json.encode(body),
      headers: headers,
    );
  }

  Future<http.Response> sendFiles(
    String method,
    String endpoint,
    Map<String, SimpleFile> files,
    Map<String, String> data,
  ) async {
    final token = await _obtainTokenOrThrow();
    final headers = _getHeaders(token.token);
    final request = http.MultipartRequest(method, _composeURL(endpoint));

    for (final fileEntry in files.entries) {
      final fileBytes = await File(fileEntry.value.path).readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(fileEntry.key, fileBytes, filename: 'file'));
    }

    for (final fieldEntry in data.entries) {
      final value = fieldEntry.value;
      request.fields[fieldEntry.key] = value;
    }

    for (final header in headers.entries) {
      request.headers[header.key] = header.value;
    }

    final response = await _httpClient.send(request);
    return http.Response.fromStream(response);
  }

  Future<Token> _obtainTokenOrThrow() async {
    late final Token token;
    final tokenEither = await _getToken(NoParams());
    tokenEither.fold(
      (failure) => throw NoTokenException(),
      (gotToken) => token = gotToken,
    );
    return token;
  }

  Map<String, String> _getHeaders(String token) => {
        'Authorization': 'Token $token',
        'Accept': "application/json",
      };
  Uri _composeURL(String endpoint, [Map<String, String>? queryParams]) {
    return useHTTPS ? Uri.https(_apiHost, endpoint, queryParams) : Uri.http(_apiHost, endpoint, queryParams);
  }
}
