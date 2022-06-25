import 'package:socnet/core/const/endpoints.dart';

class URLMapper {
  String shortToLong(String short) => apiHost + short;
  String longToShort(String long) => long.replaceFirst(apiHost, '');
}
