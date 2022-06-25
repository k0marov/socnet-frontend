import 'package:equatable/equatable.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';

class TokenModel extends Equatable {
  final Token _entity;
  @override
  List get props => [_entity];
  const TokenModel(this._entity);

  Token toEntity() => _entity;

  TokenModel.fromJson(Map<String, dynamic> json)
      : this(Token(token: json['token']));

  Map<String, dynamic> toJson() => {'token': _entity.token};
}
