part of 'boxlist_bloc.dart';

enum BoxlistStateStatus { initial, inProcess, searchProcess, success, failure }

abstract class BoxlistState extends Equatable {
  const BoxlistState();

  @override
  List<Object> get props => [];
}

class BoxlistLoadSuccess extends BoxlistState {
  final BoxlistStateStatus status;
  final List<StorePack> storePack;

  BoxlistLoadSuccess({
    BoxlistStateStatus? status,
    List<StorePack>? storePack,
  })  : this.status = BoxlistStateStatus.initial,
        this.storePack = storePack ?? <StorePack>[];

  BoxlistLoadSuccess copyWith({
    BoxlistStateStatus? status,
    List<StorePack>? storePack,
  }) {
    return BoxlistLoadSuccess(
      status: status ?? this.status,
      storePack: storePack ?? this.storePack,
    );
  }

  @override
  List<Object> get props => [
        status,
        storePack,
      ];
}

class BoxlistInitial extends BoxlistState {}

class BoxlistInProgress extends BoxlistState {}

class BoxlistScanProductFailure extends BoxlistState {
  final String message;
  BoxlistScanProductFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class BoxlistLoadFailure extends BoxlistState {
  final String message;
  BoxlistLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
