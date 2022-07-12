import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

abstract class TokenMapper {
  Token fromJson(Map<String, dynamic> json);
}

class TokenMapperImpl implements TokenMapper {
  @override
  Token fromJson(Map<String, dynamic> json) {
    try {
      return Token(token: json['token']);
    } catch (e) {
      throw MappingException();
    }
  }
}
