part of 'customer_bloc.dart';

enum CustomerStateStatus { initial, inProcess, searchProcess, success, failure }

class CustomerState extends Equatable {
  const CustomerState({
    this.status = CustomerStateStatus.initial,
    this.customer = const <Customer>[],
  });

  final CustomerStateStatus status;

  final List<Customer> customer;

  CustomerState copyWith({
    CustomerStateStatus? status,
    List<Customer>? customer,
  }) {
    return CustomerState(
      status: status ?? this.status,
      customer: customer ?? this.customer,
    );
  }

  @override
  List<Object> get props => [status, customer];
}
