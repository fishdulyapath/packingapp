import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/customer.dart';
import 'package:mobilepacking/data/struct/dropoff.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final ProductRepository _productRepository;

  CustomerBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(CustomerState(
          status: CustomerStateStatus.initial,
          customer: <Customer>[],
        ));

  @override
  Stream<CustomerState> mapEventToState(
    CustomerEvent event,
  ) async* {
    if (event is CustomerLoad) {
      yield* _mapDropoffStartedToState(event);
    }
  }

  Stream<CustomerState> _mapDropoffStartedToState(CustomerLoad event) async* {
    try {
      List<Customer> previousDropoff = <Customer>[];

      CustomerState previousState = state.copyWith();

      yield state.copyWith(status: CustomerStateStatus.inProcess);

      final dataResponse = await _productRepository.fetchAllCustomer();

      List<Customer> customer = (dataResponse.data as List)
          .map((customer) => Customer.fromMap(customer))
          .toList();

      yield state.copyWith(
        status: CustomerStateStatus.success,
        customer: customer,
      );
    } catch (e) {
      yield CustomerState(status: CustomerStateStatus.failure);
    }
  }
}
