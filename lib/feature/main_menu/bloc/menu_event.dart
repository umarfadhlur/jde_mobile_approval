part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {}

class MenuGetAN8 extends MenuEvent {
  final GetAn8 an8;

  MenuGetAN8({required this.an8});

  @override
  List<Object> get props => [an8];
}

class GetAN8Input extends MenuEvent {
  final String token;
  final String val;
  final String co;
  final String status;

  GetAN8Input(
      {required this.co,
      required this.token,
      required this.val,
      required this.status});

  @override
  List<Object> get props => [token, val, co, status];
}

class MenuGetCountWO extends MenuEvent {
  final ResponseCountWo countWo;

  MenuGetCountWO({required this.countWo});

  @override
  List<Object> get props => [countWo];
}

class GetF980051 extends MenuEvent {
  final String username;

  GetF980051({required this.username});

  @override
  List<Object> get props => [username];
}

class GetWatch extends MenuEvent {
  final String username;

  GetWatch({required this.username});

  @override
  List<Object> get props => [username];
}

class GetNewWatch extends MenuEvent {
  final String username;

  GetNewWatch({required this.username});

  @override
  List<Object> get props => [username];
}

class GetAll extends MenuEvent {
  final String username;

  GetAll({required this.username});

  @override
  List<Object> get props => [username];
}
