part of 'docdetail_bloc.dart';

enum DocdetailStateStatus {
  initial,
  inProcess,
  searchProcess,
  success,
  failure
}

abstract class DocdetailState extends Equatable {
  const DocdetailState();

  @override
  List<Object> get props => [];
}

class DocDetailLoadSuccess extends DocdetailState {
  final DocdetailStateStatus status;
  final List<DocDetail> docDetail;

  DocDetailLoadSuccess({
    DocdetailStateStatus? status,
    List<DocDetail>? docDetail,
  })  : this.status = DocdetailStateStatus.initial,
        this.docDetail = docDetail ?? <DocDetail>[];

  DocDetailLoadSuccess copyWith({
    DocdetailStateStatus? status,
    List<DocDetail>? docdetail,
  }) {
    return DocDetailLoadSuccess(
      status: status ?? this.status,
      docDetail: docdetail ?? this.docDetail,
    );
  }

  @override
  List<Object> get props => [
        status,
        docDetail,
      ];
}

class DocDetailReLoadSuccess extends DocdetailState {
  final DocdetailStateStatus status;
  final List<DocDetail> docDetail;

  DocDetailReLoadSuccess({
    DocdetailStateStatus? status,
    List<DocDetail>? docDetail,
  })  : this.status = DocdetailStateStatus.initial,
        this.docDetail = docDetail ?? <DocDetail>[];

  DocDetailReLoadSuccess copyWith({
    DocdetailStateStatus? status,
    List<DocDetail>? docdetail,
  }) {
    return DocDetailReLoadSuccess(
      status: status ?? this.status,
      docDetail: docdetail ?? this.docDetail,
    );
  }

  @override
  List<Object> get props => [
        status,
        docDetail,
      ];
}

class DocdetailReLoadInitial extends DocdetailState {}

class DocdetailReLoadInProgress extends DocdetailState {}

class DocdetailInitial extends DocdetailState {}

class DocdetailInProgress extends DocdetailState {}

class DocdetailReLoadFailure extends DocdetailState {
  final String message;
  DocdetailReLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class DocdetailScanProductFailure extends DocdetailState {
  final String message;
  DocdetailScanProductFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class DocdetailLoadFailure extends DocdetailState {
  final String message;
  DocdetailLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
