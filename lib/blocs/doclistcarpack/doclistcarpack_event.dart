part of 'doclistcarpack_bloc.dart';

abstract class DoclistCarEvent extends Equatable {
  const DoclistCarEvent();

  @override
  List<Object> get props => [];
}

class DoclistCarLoaded extends DoclistCarEvent {
  late final String docNo;
  final String keyWord;
  final String fromDate;
  final String toDate;
  final String branchCode;
  DoclistCarLoaded({
    this.keyWord = "",
    this.fromDate = "",
    this.toDate = "",
    this.branchCode = "",
  });

  @override
  List<Object> get props => [keyWord, fromDate, toDate, branchCode];
}
