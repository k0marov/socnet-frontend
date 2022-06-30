import 'package:http/http.dart' as http;

import 'exceptions.dart';

/// protects from unknown exceptions by substituting them for NetworkException.unknown()
/// should be used in datasources
Future<T> exceptionConverterCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } catch (e) {
    if (e is NoTokenException) rethrow;
    if (e is NetworkException) rethrow;
    throw const NetworkException.unknown();
  }
}

void checkStatusCode(http.Response response) {
  if (response.statusCode != 200) {
    throw NetworkException.fromApiResponse(
      response.statusCode,
      response.body,
    );
  }
}
