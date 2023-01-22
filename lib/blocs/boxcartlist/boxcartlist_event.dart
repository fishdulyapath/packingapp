part of 'boxcartlist_bloc.dart';

abstract class BoxcartlistEvent extends Equatable {
  const BoxcartlistEvent();

  @override
  List<Object> get props => [];
}

class BoxcartlistLoaded extends BoxcartlistEvent {
  final String docNo;

  BoxcartlistLoaded({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}
