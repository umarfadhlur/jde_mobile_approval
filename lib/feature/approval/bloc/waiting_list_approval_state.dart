part of 'waiting_list_approval_bloc.dart';

abstract class WaitingListApprovalState extends Equatable {}

class WaitingListApprovalInitial extends WaitingListApprovalState {
  @override
  List<Object> get props => [];
}

class ArticleLoadingState extends WaitingListApprovalState {
  @override
  List<Object> get props => [];
}

class ArticleLoadedState extends WaitingListApprovalState {
  final List<ApvList> articles;

  ArticleLoadedState({required this.articles});
  @override
  List<Object> get props => [articles];
}

class DetailLoadedState extends WaitingListApprovalState {
  final List<Detail> details;

  DetailLoadedState({required this.details});
  @override
  List<Object> get props => [details];
}

class ArticleErrorState extends WaitingListApprovalState {
  final String message;

  ArticleErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class DetailErrorState extends WaitingListApprovalState {
  final String message;

  DetailErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class RejectSuccess extends WaitingListApprovalState {
  final String message;

  RejectSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class RejectFailed extends WaitingListApprovalState {
  final String message;

  RejectFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class ApproveSuccess extends WaitingListApprovalState {
  final String message;

  ApproveSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ApproveFailed extends WaitingListApprovalState {
  final String message;

  ApproveFailed({required this.message});

  @override
  List<Object> get props => [message];
}
