part of 'doclistsend_bloc.dart';

abstract class DoclistSendEvent extends Equatable {
  const DoclistSendEvent();

  @override
  List<Object> get props => [];
}

class DoclistSendLoaded extends DoclistSendEvent {
  late final String docNo;
  final String keyWord;
  final String fromDate;
  final String toDate;
  final String branchCode;
  DoclistSendLoaded({
    this.keyWord = "",
    this.fromDate = "",
    this.toDate = "",
    this.branchCode = "",
  });

  @override
  List<Object> get props => [keyWord, fromDate, toDate, branchCode];
}
