import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:socnet/core/const/api.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/simple_file/simple_file.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';

class AuthenticatedAPIFacade {
  final http.Client _httpClient;
  AuthenticatedAPIFacade(this._httpClient);

  Token? _token;
  void setToken(Token? newToken) => _token = newToken;

  Future<http.Response> get(String endpoint, Map<String, dynamic> body) {
    final tokenEntity = _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    return _httpClient.get(Uri.https(apiHost, endpoint, body),
        headers: headers);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) {
    final tokenEntity = _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    return _httpClient.post(
      Uri.https(apiHost, endpoint),
      body: body,
      headers: headers,
    );
  }

  Future<http.Response> delete(String endpoint) {
    final tokenEntity = _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    return _httpClient.delete(
      Uri.https(apiHost, endpoint),
      headers: headers,
    );
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) {
    final tokenEntity = _obtainTokenOrThrow();
    final headers = _getHeaders(tokenEntity.token);
    return _httpClient.put(
      Uri.https(apiHost, endpoint),
      body: body,
      headers: headers,
    );
  }

  Future<http.Response> sendFiles(
    String method,
    String endpoint,
    Map<String, SimpleFile> files,
    Map<String, String> data,
  ) async {
    final headers = _getHeaders(_obtainTokenOrThrow().token);
    final request = http.MultipartRequest(method, Uri.https(apiHost, endpoint));

    for (final fileEntry in files.entries) {
      final fileBytes = await File(fileEntry.value.path).readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(fileEntry.key, fileBytes,
          filename: 'file'));
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

  Token _obtainTokenOrThrow() {
    final token = _token;
    if (token != null) {
       return token;
    } else {
      throw NoTokenException();
    }
  }

  Map<String, String> _getHeaders(String token) => {
        'Authorization': 'Token $token',
        'Accept': "application/json",
      };
}
