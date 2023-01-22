part of 'doclistcarpack_bloc.dart';

enum DoclistCarStateStatus {
  initial,
  inProcess,
  searchProcess,
  success,
  failure
}

class DoclistCarState extends Equatable {
  const DoclistCarState({
    this.status = DoclistCarStateStatus.initial,
    this.doclistCar = const <DoclistCar>[],
  });

  final DoclistCarStateStatus status;
  final List<DoclistCar> doclistCar;

  DoclistCarState copyWith({
    DoclistCarStateStatus? status,
    List<DoclistCar>? doclistCar,
  }) {
    return DoclistCarState(
      status: status ?? this.status,
      doclistCar: doclistCar ?? this.doclistCar,
    );
  }

  @override
  List<Object> get props => [status, doclistCar];
}

class DoclistCarInitial extends DoclistCarState {}

class DoclistCarInProgress extends DoclistCarState {}

class DoclistCarScanProductFailure extends DoclistCarState {
  final String message;
  DoclistCarScanProductFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class DoclistCarLoadFailure extends DoclistCarState {}
