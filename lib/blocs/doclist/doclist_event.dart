part of 'doclist_bloc.dart';

abstract class DoclistEvent extends Equatable {
  const DoclistEvent();

  @override
  List<Object> get props => [];
}

class DoclistLoaded extends DoclistEvent {
  late final String docNo;
  final String keyWord;
  final String fromDate;
  final String toDate;
  final String branchCode;
  final String status;
  DoclistLoaded({
    this.keyWord = "",
    this.fromDate = "",
    this.toDate = "",
    this.branchCode = "",
    this.status = "",
  });

  @override
  List<Object> get props => [keyWord, fromDate, toDate, branchCode, status];
}
