part of 'config_cubit.dart';

class ConfigState extends Equatable {
  const ConfigState({
    this.hoServiceUrl = const ServiceUrl.pure(),
    this.hoProviderName = const ProviderName.pure(),
    this.hoDatabaseName = const DatabaseName.pure(),
    this.status = FormzStatus.pure,
  });

  final ServiceUrl hoServiceUrl;
  final ProviderName hoProviderName;
  final DatabaseName hoDatabaseName;

  final FormzStatus status;

  @override
  List<Object> get props => [
        hoServiceUrl,
        hoProviderName,
        hoDatabaseName,
        status,
      ];

  ConfigState copyWith({
    ServiceUrl? hoServiceUrl,
    ProviderName? hoProviderName,
    DatabaseName? hoDatabaseName,
    FormzStatus? status,
  }) {
    return ConfigState(
      hoServiceUrl: hoServiceUrl ?? this.hoServiceUrl,
      hoProviderName: hoProviderName ?? this.hoProviderName,
      hoDatabaseName: hoDatabaseName ?? this.hoDatabaseName,
      status: status ?? this.status,
    );
  }
}
