import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/core/mapper.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

typedef TokenMapper = Mapper<Token>;

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
