part of 'menu_bloc.dart';

abstract class MenuState extends Equatable {}

class MenuInitial extends MenuState {
  @override
  List<Object> get props => [];
}

class MenuErrorState extends MenuState {
  final String message;

  MenuErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class GetWatchListSuccess extends MenuState {
  final ResponseWatchlistCountWo watchList;

  GetWatchListSuccess({required this.watchList});

  @override
  List<Object> get props => [watchList];
}

class F980051LoadedState extends MenuState {
  final List<F980051> details;

  F980051LoadedState({required this.details});
  @override
  List<Object> get props => [details];
}

class F980051FailedState extends MenuState {
  final String message;

  F980051FailedState({required this.message});

  @override
  List<Object> get props => [message];
}

class WatchlistLoadedState extends MenuState {
  final List<Watchlist> details;

  WatchlistLoadedState({required this.details});
  @override
  List<Object> get props => [details];
}

class WatchlistFailedState extends MenuState {
  final String message;

  WatchlistFailedState({required this.message});

  @override
  List<Object> get props => [message];
}

class NewWatchlistLoadedState extends MenuState {
  final List<AbConnectWatchlistRepeating> details;

  NewWatchlistLoadedState({required this.details});
  @override
  List<Object> get props => [details];
}

class NewWatchlistFailedState extends MenuState {
  final String message;

  NewWatchlistFailedState({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingState extends MenuState {
  @override
  List<Object> get props => [];
}

class GetAllSuccess extends MenuState {
  final List<F980051> notify;
  final List<AbConnectWatchlistRepeating> watchList;

  GetAllSuccess({required this.notify, required this.watchList});

  @override
  List<Object> get props => [notify, watchList];
}

class GetAllFailed extends MenuState {
  final String message;

  GetAllFailed({required this.message});

  @override
  List<Object> get props => [message];
}
