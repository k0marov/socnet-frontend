import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/core/debug.dart';
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/core/simple_file.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/logic/features/auth/domain/usecases/get_auth_token_usecase.dart';

class AuthenticatedAPIFacade {
  final http.Client _httpClient;
  final GetAuthTokenUseCase _getToken;
  final String _apiHost;
  final bool useHTTPS;

  /// useHTTPS should be set to false only in tests
  AuthenticatedAPIFacade(this._getToken, this._httpClient, this._apiHost, {this.useHTTPS = true});

  Future<http.Response> get(EndpointQuery eq) async {
    final tokenEntity = await _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    final url = eq.toURL(_apiHost, useHTTPS);
    printDebug("GET $url");
    final response = await _httpClient.get(url, headers: headers);
    printResponse(response);
    return response;
  }

  Future<http.Response> post(EndpointQuery eq, Map<String, dynamic> body) async {
    final tokenEntity = await _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    final bodyJson = json.encode(body);
    final url = eq.toURL(_apiHost, useHTTPS);
    printDebug("POST $url: $bodyJson");
    final response = await _httpClient.post(
      url,
      body: bodyJson,
      headers: headers,
    );
    printResponse(response);
    return response;
  }

  Future<http.Response> delete(EndpointQuery eq) async {
    final tokenEntity = await _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    final url = eq.toURL(_apiHost, useHTTPS);
    printDebug("DELETE $url");
    final response = await _httpClient.delete(
      url,
      headers: headers,
    );
    printResponse(response);
    return response;
  }

  Future<http.Response> put(EndpointQuery eq, Map<String, dynamic> body) async {
    final tokenEntity = await _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    final bodyJson = json.encode(body);
    final url = eq.toURL(_apiHost, useHTTPS);
    printDebug("PUT $url: $bodyJson");
    final response = await _httpClient.put(
      url,
      body: bodyJson,
      headers: headers,
    );
    printResponse(response);
    return response;
  }

  Future<http.Response> sendFiles(
    String method,
    EndpointQuery eq,
    Map<String, SimpleFile> files,
    Map<String, String> data,
  ) async {
    final token = await _obtainTokenOrThrow();
    final headers = _getHeaders(token.token);
    final url = eq.toURL(_apiHost, useHTTPS);
    final request = http.MultipartRequest(method, url);

    for (final fileEntry in files.entries) {
      final fileBytes = File(fileEntry.value.path).readAsBytesSync();
      request.files.add(http.MultipartFile.fromBytes(fileEntry.key, fileBytes, filename: 'file'));
    }

    for (final fieldEntry in data.entries) {
      final value = fieldEntry.value;
      request.fields[fieldEntry.key] = value;
    }

    for (final header in headers.entries) {
      request.headers[header.key] = header.value;
    }

    printDebug("$method $url\nFiles: $files\nData: $data");

    final responseStream = await _httpClient.send(request);
    final response = await http.Response.fromStream(responseStream);
    printResponse(response);
    return response;
  }

  Future<Token> _obtainTokenOrThrow() async {
    late final Token token;
    final tokenEither = await _getToken();
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
}
