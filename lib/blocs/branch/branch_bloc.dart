import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/repositories/branch_repository.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchRepository _branchRepository;
  BranchBloc({required BranchRepository branchRepository})
      : _branchRepository = branchRepository,
        super(BranchInitial());

  @override
  Stream<BranchState> mapEventToState(
    BranchEvent event,
  ) async* {
    if (event is BranchLoad) {
      yield* _mapBranchStartedToState(event);
    }
  }

  Stream<BranchState> _mapBranchStartedToState(event) async* {
    try {
      final dataResponse =
          await _branchRepository.fetchAllBranch(event.storeType);

      List<Branch> branches = (dataResponse.data as List)
          .map((branch) => Branch.fromMap(branch))
          .toList();
      print(branches.toString());
      print('================== ${branches.length}');
      yield BranchLoadSuccess(branches);
    } catch (e) {
      print('error ${e.toString()}');
      yield BranchLoadFailure();
    }
  }
}
