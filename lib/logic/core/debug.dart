import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void printDebug(Object? obj) {
  if (kDebugMode) {
    print(obj);
  }
}

void printResponse(http.Response response) {
  printDebug("Response: ${response.statusCode} ${response.body}");
}
