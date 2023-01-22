part of 'doclist_bloc.dart';

enum DoclistStateStatus { initial, inProcess, searchProcess, success, failure }

class DoclistState extends Equatable {
  const DoclistState({
    this.status = DoclistStateStatus.initial,
    this.doclist = const <DocList>[],
  });

  final DoclistStateStatus status;
  final List<DocList> doclist;

  DoclistState copyWith({
    DoclistStateStatus? status,
    List<DocList>? doclist,
  }) {
    return DoclistState(
      status: status ?? this.status,
      doclist: doclist ?? this.doclist,
    );
  }

  @override
  List<Object> get props => [status, doclist];
}

class DoclistInitial extends DoclistState {}

class DoclistInProgress extends DoclistState {}

class DoclistScanProductFailure extends DoclistState {
  final String message;
  DoclistScanProductFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class DoclistLoadFailure extends DoclistState {}
