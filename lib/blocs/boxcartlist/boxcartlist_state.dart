part of 'boxcartlist_bloc.dart';

enum BoxcartlistStateStatus { initial, inProcess, searchProcess, success, failure }

abstract class BoxcartlistState extends Equatable {
  const BoxcartlistState();

  @override
  List<Object> get props => [];
}

class BoxcartlistLoadSuccess extends BoxcartlistState {
  final BoxcartlistStateStatus status;
  final List<StorePack> storePack;

  BoxcartlistLoadSuccess({
    BoxcartlistStateStatus? status,
    List<StorePack>? storePack,
  })  : this.status = BoxcartlistStateStatus.initial,
        this.storePack = storePack ?? <StorePack>[];

  BoxcartlistLoadSuccess copyWith({
    BoxcartlistStateStatus? status,
    List<StorePack>? storePack,
  }) {
    return BoxcartlistLoadSuccess(
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

class BoxcartlistInitial extends BoxcartlistState {}

class BoxcartlistInProgress extends BoxcartlistState {}

class BoxcartlistScanProductFailure extends BoxcartlistState {
  final String message;
  BoxcartlistScanProductFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class BoxcartlistLoadFailure extends BoxcartlistState {
  final String message;
  BoxcartlistLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
