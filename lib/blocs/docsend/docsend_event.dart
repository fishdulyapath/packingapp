part of 'docsend_bloc.dart';

abstract class DocsendEvent extends Equatable {
  const DocsendEvent();

  @override
  List<Object> get props => [];
}

class DocsendLoad extends DocsendEvent {
  String docno;
  List<String> docbo;
  String imagebase64;

  DocsendLoad(
      {required this.docno, required this.docbo, required this.imagebase64});
}
