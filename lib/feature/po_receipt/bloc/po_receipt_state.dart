part of 'po_receipt_bloc.dart';

abstract class PoReceiptState extends Equatable {}

class PoReceiptInitial extends PoReceiptState {
  @override
  List<Object> get props => [];
}

class SuccessEntry extends PoReceiptState {
  final String message;

  SuccessEntry({required this.message});

  @override
  List<Object> get props => [message];
}

class FailedEntry extends PoReceiptState {
  final String message;

  FailedEntry({required this.message});

  @override
  List<Object> get props => [message];
}

class LotFound extends PoReceiptState {
  final String message;

  LotFound({required this.message});

  @override
  List<Object> get props => [message];
}

class LotNotFound extends PoReceiptState {
  final String message;

  LotNotFound({required this.message});

  @override
  List<Object> get props => [message];
}

class QtyUomLoaded extends PoReceiptState {
  final List<QtyUom> qtyuoms;

  QtyUomLoaded({required this.qtyuoms});

  @override
  List<Object> get props => [qtyuoms];
}

class QtyNotFound extends PoReceiptState {
  final String message;

  QtyNotFound({required this.message});

  @override
  List<Object> get props => [message];
}

class ItemDescLoaded extends PoReceiptState {
  final List<ItemDesc> descs;

  ItemDescLoaded({required this.descs});

  @override
  List<Object> get props => [descs];
}

class ItemDescNotFound extends PoReceiptState {
  final String message;

  ItemDescNotFound({required this.message});

  @override
  List<Object> get props => [message];
}
