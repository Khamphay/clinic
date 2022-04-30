import 'package:equatable/equatable.dart';

import 'package:clinic/model/customer_model.dart';

abstract class CustomerState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class CustomerInitailState extends CustomerState {}

class CustomerLoadingState extends CustomerState {}

class CustomerLoadCompletedState extends CustomerState {
  final List<CustomerModel> customers;

  CustomerLoadCompletedState({
    required this.customers,
  });
}

class CustomerErrorState extends CustomerState {
  final String error;
  CustomerErrorState({
    required this.error,
  });
}
