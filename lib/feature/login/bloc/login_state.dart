part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends LoginState {
  final String username;
  final String environment;
  final String token;

  LoginSuccessState(
      {required this.username, required this.environment, required this.token});

  @override
  List<Object> get props => [username, environment, token];
}

class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class LogoutSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

class LogoutErrorState extends LoginState {
  final String message;

  LogoutErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
