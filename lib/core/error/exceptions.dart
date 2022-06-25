import 'dart:convert';

import 'package:equatable/equatable.dart';

class NoTokenException implements Exception {}

class CacheException implements Exception {}

/// statusCode == -1 means "Unknown, probably no internet connection"
class NetworkException extends Equatable implements Exception {
  final int statusCode;
  final String? detail;

  @override
  List get props => [statusCode, detail];

  const NetworkException(this.statusCode, this.detail);
  const NetworkException.unknown() : this(-1, null);

  NetworkException.fromApiResponse(int statusCode, String jsonBody)
      : this(
          statusCode,
          _safeJsonDecode(jsonBody),
        );

  static String? _safeJsonDecode(String jsonBody) {
    try {
      return json.decode(jsonBody)['detail'];
    } catch (e) {
      return null;
    }
  }
}
