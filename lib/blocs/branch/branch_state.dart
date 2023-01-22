part of 'branch_bloc.dart';

abstract class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object> get props => [];
}

class BranchInitial extends BranchState {}

class BranchLoadSuccess extends BranchState {
  final List<Branch> branches;

  const BranchLoadSuccess([this.branches = const []]);

  @override
  List<Object> get props => [branches];
}

class BranchLoadFailure extends BranchState {}
