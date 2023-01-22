part of 'boxsend_bloc.dart';

abstract class BoxsendEvent extends Equatable {
  const BoxsendEvent();

  @override
  List<Object> get props => [];
}

class BoxsendLoad extends BoxsendEvent {
  String docno;
  int status;

  BoxsendLoad({required this.docno, required this.status});
}
