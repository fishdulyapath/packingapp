part of 'docsend_bloc.dart';

abstract class DocsendState extends Equatable {
  const DocsendState();

  @override
  List<Object> get props => [];
}

class DocsendInitial extends DocsendState {}

class DocsendLoadSuccess extends DocsendState {
  @override
  List<Object> get props => [];
}

class DocsendLoadFailure extends DocsendState {
  final String message;
  DocsendLoadFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
