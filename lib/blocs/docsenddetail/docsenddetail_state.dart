part of 'docsenddetail_bloc.dart';

enum DocSenddetailStateStatus {
  initial,
  inProcess,
  searchProcess,
  success,
  failure
}

abstract class DocSenddetailState extends Equatable {
  const DocSenddetailState();

  @override
  List<Object> get props => [];
}

class DocSendDetailLoadSuccess extends DocSenddetailState {
  final DocSenddetailStateStatus status;
  final List<DocDetailSend> docDetailSend;

  DocSendDetailLoadSuccess({
    DocSenddetailStateStatus? status,
    List<DocDetailSend>? docDetailSend,
  })  : this.status = DocSenddetailStateStatus.initial,
        this.docDetailSend = docDetailSend ?? <DocDetailSend>[];

  DocSendDetailLoadSuccess copyWith({
    DocSenddetailStateStatus? status,
    List<DocDetailSend>? docDetailSend,
  }) {
    return DocSendDetailLoadSuccess(
      status: status ?? this.status,
      docDetailSend: docDetailSend ?? this.docDetailSend,
    );
  }

  @override
  List<Object> get props => [
        status,
        docDetailSend,
      ];
}

class DocSendDetailReLoadSuccess extends DocSenddetailState {
  final DocSenddetailStateStatus status;
  final List<DocDetailSend> docDetailSend;

  DocSendDetailReLoadSuccess({
    DocSenddetailStateStatus? status,
    List<DocDetailSend>? docDetailSend,
  })  : this.status = DocSenddetailStateStatus.initial,
        this.docDetailSend = docDetailSend ?? <DocDetailSend>[];

  DocSendDetailReLoadSuccess copyWith({
    DocSenddetailStateStatus? status,
    List<DocDetailSend>? docDetailSend,
  }) {
    return DocSendDetailReLoadSuccess(
      status: status ?? this.status,
      docDetailSend: docDetailSend ?? this.docDetailSend,
    );
  }

  @override
  List<Object> get props => [
        status,
        docDetailSend,
      ];
}

class DocSenddetailReLoadInitial extends DocSenddetailState {}

class DocSenddetailReLoadInProgress extends DocSenddetailState {}

class DocSenddetailInitial extends DocSenddetailState {}

class DocSenddetailInProgress extends DocSenddetailState {}

class DocSenddetailReLoadFailure extends DocSenddetailState {
  final String message;
  DocSenddetailReLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class DocSenddetailScanProductFailure extends DocSenddetailState {
  final String message;
  DocSenddetailScanProductFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class DocSenddetailLoadFailure extends DocSenddetailState {
  final String message;
  DocSenddetailLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
