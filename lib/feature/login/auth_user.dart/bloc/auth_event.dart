part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Fired just after the app is launched
class AppLoaded extends AuthEvent {}

// Fired when a user has successfully logged in
class UserLoggedIn extends AuthEvent {
  // final String token;
  // final String co;
  // final String address;

  // UserLoggedIn({@required this.token, @required this.co, @required this.address});

  // @override
  // List<Object> get props => [token, co, address];
}

// Fired when the user has logged out
class UserLoggedOut extends AuthEvent {}
