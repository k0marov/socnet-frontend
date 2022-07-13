import 'dart:convert';

import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  @override
  List get props => [];
  const Failure();
}

class UnknownFailure extends Failure {
  final dynamic exception;
  @override
  List get props => [exception];
  const UnknownFailure(this.exception);
}

class NoTokenFailure extends Failure {}

class CacheFailure extends Failure {}

class MappingFailure extends Failure {}

class NetworkFailure extends Failure {
  final int statusCode;
  final ClientError? clientError;

  @override
  List get props => [statusCode, clientError];

  const NetworkFailure(this.statusCode, this.clientError);

  NetworkFailure.fromApiResponse(int statusCode, String jsonBody)
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
          json['detail_code'],
          json['readable_detail'],
        );
  Map<String, dynamic> toJson() => {
        'detail_code': detailCode,
        'readable_detail': readableDetail,
      };
}
