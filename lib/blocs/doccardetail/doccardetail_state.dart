part of 'doccardetail_bloc.dart';

enum DoccardetailStateStatus {
  initial,
  inProcess,
  searchProcess,
  success,
  failure
}

abstract class DoccardetailState extends Equatable {
  const DoccardetailState();

  @override
  List<Object> get props => [];
}

class DoccarDetailLoadSuccess extends DoccardetailState {
  final DoccardetailStateStatus status;
  final List<DocDetailCar> doccarDetail;

  DoccarDetailLoadSuccess({
    DoccardetailStateStatus? status,
    List<DocDetailCar>? doccarDetail,
  })  : this.status = DoccardetailStateStatus.initial,
        this.doccarDetail = doccarDetail ?? <DocDetailCar>[];

  DoccarDetailLoadSuccess copyWith({
    DoccardetailStateStatus? status,
    List<DocDetailCar>? doccardetail,
  }) {
    return DoccarDetailLoadSuccess(
      status: status ?? this.status,
      doccarDetail: doccardetail ?? this.doccarDetail,
    );
  }

  @override
  List<Object> get props => [
        status,
        doccarDetail,
      ];
}

class DoccarDetailReLoadSuccess extends DoccardetailState {
  final DoccardetailStateStatus status;
  final List<DocDetailCar> doccarDetail;

  DoccarDetailReLoadSuccess({
    DoccardetailStateStatus? status,
    List<DocDetailCar>? doccarDetail,
  })  : this.status = DoccardetailStateStatus.initial,
        this.doccarDetail = doccarDetail ?? <DocDetailCar>[];

  DoccarDetailReLoadSuccess copyWith({
    DoccardetailStateStatus? status,
    List<DocDetailCar>? doccardetail,
  }) {
    return DoccarDetailReLoadSuccess(
      status: status ?? this.status,
      doccarDetail: doccardetail ?? this.doccarDetail,
    );
  }

  @override
  List<Object> get props => [
        status,
        doccarDetail,
      ];
}

class DoccardetailReLoadInitial extends DoccardetailState {}

class DoccardetailReLoadInProgress extends DoccardetailState {}

class DoccardetailInitial extends DoccardetailState {}

class DoccardetailInProgress extends DoccardetailState {}

class DoccardetailReLoadFailure extends DoccardetailState {
  final String message;
  DoccardetailReLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class DoccardetailScanProductFailure extends DoccardetailState {
  final String message;
  DoccardetailScanProductFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class DoccardetailLoadFailure extends DoccardetailState {
  final String message;
  DoccardetailLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
