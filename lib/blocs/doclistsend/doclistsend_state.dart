part of 'doclistsend_bloc.dart';

enum DoclistSendStateStatus {
  initial,
  inProcess,
  searchProcess,
  success,
  failure
}

class DoclistSendState extends Equatable {
  const DoclistSendState({
    this.status = DoclistSendStateStatus.initial,
    this.doclistSend = const <DoclistSend>[],
  });

  final DoclistSendStateStatus status;
  final List<DoclistSend> doclistSend;

  DoclistSendState copyWith({
    DoclistSendStateStatus? status,
    List<DoclistSend>? DoclistSend,
  }) {
    return DoclistSendState(
      status: status ?? this.status,
      doclistSend: DoclistSend ?? this.doclistSend,
    );
  }

  @override
  List<Object> get props => [status, DoclistSend];
}

class DoclistSendInitial extends DoclistSendState {}

class DoclistSendInProgress extends DoclistSendState {}

class DoclistSendScanProductFailure extends DoclistSendState {
  final String message;
  DoclistSendScanProductFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class DoclistSendLoadFailure extends DoclistSendState {}
