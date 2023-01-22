part of 'boxlist_bloc.dart';

abstract class BoxlistEvent extends Equatable {
  const BoxlistEvent();

  @override
  List<Object> get props => [];
}

class BoxlistLoaded extends BoxlistEvent {
  final String docNo;

  BoxlistLoaded({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}
