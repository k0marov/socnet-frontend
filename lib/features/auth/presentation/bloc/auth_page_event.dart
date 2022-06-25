part of 'auth_page_bloc.dart';

abstract class AuthPageEvent extends Equatable {
  const AuthPageEvent();

  @override
  List<Object> get props => [];
}

class SwitchedToRegistration extends AuthPageEvent {}
class SwitchedToLogin extends AuthPageEvent {} 
class LoginRequested extends AuthPageEvent {
  final String username, password; 
  @override 
  List<Object> get props => [username, password]; 

  const LoginRequested({
    required this.username, 
    required this.password
  });
}
class RegistrationRequested extends AuthPageEvent {
  final String username, password; 
  @override 
  List<Object> get props => [username, password]; 

  const RegistrationRequested({
    required this.username, 
    required this.password, 
  });
}