import 'dart:convert';

import 'package:equatable/equatable.dart';

class NoTokenException extends Equatable implements Exception {
  @override
  List<Object?> get props => [];
}

class CacheException extends Equatable implements Exception {
  @override
  List<Object?> get props => [];
}

class HashingException extends Equatable implements Exception {
  @override
  List<Object?> get props => [];
}

class MappingException extends Equatable implements Exception {
  @override
  List get props => [];
}

/// statusCode == -1 means "Unknown, probably no internet connection"
class NetworkException extends Equatable implements Exception {
  final int statusCode;
  final ClientError? clientError;

  @override
  List get props => [statusCode, clientError];

  const NetworkException(this.statusCode, this.clientError);
  const NetworkException.unknown() : this(-1, null);

  NetworkException.fromApiResponse(int statusCode, String jsonBody)
      : this(
          statusCode,
          _safeJsonDecode(jsonBody),
        );

  static ClientError? _safeJsonDecode(String jsonBody) {
    try {
      return ClientError.fromJson(json.decode(jsonBody));
    } catch (e) {
      return null;
    }
  }
}

class ClientError extends Equatable {
  final String detailCode;
  final String readableDetail;
  @override
  List get props => [detailCode, readableDetail];

  const ClientError(this.detailCode, this.readableDetail);

  ClientError.fromJson(Map<String, dynamic> json)
      : this(
          json['detail_code'] as String,
          json['readable_detail'] as String,
        );
  Map<String, dynamic> toJson() => {
        'detail_code': detailCode,
        'readable_detail': readableDetail,
      };
}
