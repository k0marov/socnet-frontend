part of 'auth_page_bloc.dart';

abstract class AuthPageState extends Equatable {
  const AuthPageState();
  
  @override
  List<Object> get props => [];
}

class AuthPageLogin extends AuthPageState {
  const AuthPageLogin();
}

class AuthPageLoading extends AuthPageState {
  const AuthPageLoading(); 
} 

class AuthPageRegistration extends AuthPageState {
  const AuthPageRegistration(); 
} 

class AuthPageLoginFailure extends AuthPageLogin {
  final String username, password; 
  final Failure failure; 
  @override 
  List<Object> get props => [username, password, failure]; 

  const AuthPageLoginFailure({
    required this.username, 
    required this.password, 
    required this.failure,
  }); 
} 
class AuthPageRegistrationFailure extends AuthPageRegistration {
  final String username, password; 
  final Failure failure; 
  @override 
  List<Object> get props => [username, password, failure]; 

  const AuthPageRegistrationFailure({
    required this.username, 
    required this.password, 
    required this.failure, 
  });
} 

