part of 'dropoff_bloc.dart';

enum DropoffStateStatus { initial, inProcess, searchProcess, success, failure }

class DropoffState extends Equatable {
  const DropoffState({
    this.status = DropoffStateStatus.initial,
    this.dropoff = const <Dropoff>[],
  });

  final DropoffStateStatus status;

  final List<Dropoff> dropoff;

  DropoffState copyWith({
    DropoffStateStatus? status,
    List<Dropoff>? dropoff,
  }) {
    return DropoffState(
      status: status ?? this.status,
      dropoff: dropoff ?? this.dropoff,
    );
  }

  @override
  List<Object> get props => [status, dropoff];
}
