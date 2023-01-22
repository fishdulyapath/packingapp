part of 'boxscan_bloc.dart';

abstract class BoxscanEvent extends Equatable {
  const BoxscanEvent();

  @override
  List<Object> get props => [];
}

class BoxscanLoad extends BoxscanEvent {
  String docno;
  String docjo;
  BoxscanLoad({required this.docno, required this.docjo});
}
