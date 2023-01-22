part of 'boxscan_bloc.dart';

abstract class BoxscanState extends Equatable {
  const BoxscanState();

  @override
  List<Object> get props => [];
}

class BoxscanInitial extends BoxscanState {}

class BoxscanLoadSuccess extends BoxscanState {
  final List<BoxScan> detail;

  const BoxscanLoadSuccess([this.detail = const []]);

  @override
  List<Object> get props => [detail];
}

class BoxscanLoadFailure extends BoxscanState {
  final String message;
  BoxscanLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
