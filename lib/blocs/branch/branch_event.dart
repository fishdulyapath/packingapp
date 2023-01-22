part of 'branch_bloc.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object> get props => [];
}

class BranchLoad extends BranchEvent {
  final StoreType storeType;
  BranchLoad({required this.storeType});
}
