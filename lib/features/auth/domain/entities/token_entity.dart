import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String token; 
  @override 
  List get props => [token]; 
  const Token({required this.token});
}