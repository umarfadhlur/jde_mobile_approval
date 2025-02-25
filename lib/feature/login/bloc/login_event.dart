part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {}

class LoginSubmit extends LoginEvent {
  final String username;
  final String password;

  LoginSubmit({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class LogoutSubmit extends LoginEvent {
  final String token;

  LogoutSubmit({required this.token});

  @override
  List<Object> get props => [token];
}
