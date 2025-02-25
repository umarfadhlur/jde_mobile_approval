part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthState {}

class AuthenticationLoading extends AuthState {}

class AuthenticationNotAuthenticated extends AuthState {}

class AuthenticationAuthenticated extends AuthState {
  final String token;
  final String co;
  final String address;

  AuthenticationAuthenticated(
      {required this.token, required this.co, required this.address});

  @override
  List<Object> get props => [token, co, address];
}

class AuthenticationFailure extends AuthState {
  final String message;

  AuthenticationFailure({required this.message});

  @override
  List<Object> get props => [message];
}
