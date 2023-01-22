part of 'boxsend_bloc.dart';

abstract class BoxsendState extends Equatable {
  const BoxsendState();

  @override
  List<Object> get props => [];
}

class BoxsendInitial extends BoxsendState {}

class BoxsendLoadSuccess extends BoxsendState {
  @override
  List<Object> get props => [];
}

class BoxsendLoadFailure extends BoxsendState {
  final String message;
  BoxsendLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
